from flask import Flask, flash, render_template, request, redirect, url_for, session, jsonify, render_template_string, send_from_directory
from flask_mysqldb import MySQL
import sqlite3 
import os

app = Flask(__name__, template_folder='./templates')
app.secret_key = "erick"

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'AsociaciónDeportiva'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
mysql = MySQL(app)

@app.route('/inicio')
def inicio():
    return render_template('InicioSesión.html')   

@app.route('/', methods=['GET', 'POST'])
def home():
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        ID_jornada = request.form.get('ID_jornada', 1)
    else:
        ID_jornada = 1

    cur.execute("""
        SELECT p.Goles_Local, p.Goles_Visita, p.Ubicacion, p.Fecha, e1.Nombre AS Equipo_Local, e2.Nombre AS Equipo_Visitante, c.Nombre AS Nombre_Categoria, p.ID AS Partido_ID
        FROM partido p
        JOIN equipo e1 ON p.Equipo_Local_ID = e1.ID
        JOIN equipo e2 ON p.Equipo_Visitante_ID = e2.ID
        JOIN categoria c ON p.ID_categoria = c.ID
        WHERE p.ID_jornada = %s
    """, (ID_jornada,))
    partidos = cur.fetchall()

    cur.execute("""
        SELECT gj.Partido_ID, j.Nombre, j.Apellido_Paterno, j.Apellido_Materno, gj.Goles, e.Nombre AS Nombre_Equipo
        FROM goles_jugador gj
        INNER JOIN jugador j ON gj.Jugador_ID = j.ID
        INNER JOIN equipo e ON j.Equipo_ID = e.ID
        WHERE gj.Jornada = %s
    """, (ID_jornada,))
    goles_por_partido = cur.fetchall()

    categorias = defaultdict(list)
    for partido in partidos:
        categoria_nombre = partido['Nombre_Categoria']
        partido_info = {
            'Equipo_Local': partido['Equipo_Local'],
            'Goles_Local': partido['Goles_Local'],
            'Goles_Visita': partido['Goles_Visita'],
            'Equipo_Visitante': partido['Equipo_Visitante'],
            'Ubicacion': partido['Ubicacion'],
            'Fecha': partido['Fecha'],
            'Partido_ID': partido['Partido_ID'],
            'Jugadores': []
        }
        for gol in goles_por_partido:
            if gol['Partido_ID'] == partido['Partido_ID']:
                jugador_info = {
                    'Nombre': f"{gol['Nombre']} {gol['Apellido_Paterno']} {gol['Apellido_Materno']}",
                    'Goles': gol['Goles'],
                    'Equipo': gol['Nombre_Equipo']
                }
                partido_info['Jugadores'].append(jugador_info)

        categorias[categoria_nombre].append(partido_info)

    categorias = dict(categorias)
    return render_template("index.html", categorias=categorias, ID_jornada=int(ID_jornada))
  

@app.route('/admin')
def admin():
    cur = mysql.connection.cursor()
    cur.execute("SELECT Nombre FROM usuarios WHERE id = 1")
    usuario = cur.fetchone()
    nombre_usuario = usuario[0] if usuario else "Nombre no encontrado"
    return render_template('admin.html', nombre_usuario=nombre_usuario)


# Ruta para obtener los datos de los jugadores y sus estadísticas
@app.route('/admin-jugadores')
def obtener_estadisticas_jugadores():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT j.ID, j.Nombre, j.Apellido_Paterno, j.Apellido_Materno, 
               eq.Nombre AS Nombre_Equipo, c.Nombre AS Nombre_Categoria,
               SUM(gj.Goles) AS Goles_Anotados,
               SUM(gj.Tarjetas_Amarillas) AS Tarjetas_Amarillas,
               SUM(gj.Tarjetas_Rojas) AS Tarjetas_Rojas,
               GROUP_CONCAT(DISTINCT gj.Sanciones ORDER BY gj.Jornada) AS Sanciones
        FROM jugador j
        LEFT JOIN equipo eq ON j.Equipo_ID = eq.ID
        LEFT JOIN categoria c ON j.Categoria_ID = c.ID
        LEFT JOIN goles_jugador gj ON j.ID = gj.Jugador_ID
        GROUP BY j.ID
    """)
    jugadores = cur.fetchall()
    cur.close()
    return render_template('adminjugadores.html', jugadores=jugadores)


@app.route('/registrar-estadisticas', methods=['POST'])
def registrar_estadisticas():
    jugador_id = request.form['jugadorId']
    jornada = request.form['jornada']
    goles = request.form['goles']
    amarillas = request.form['amarillas']
    rojas = request.form['rojas']
    sanciones = request.form['sanciones']

    # Obtener el Partido_ID correspondiente
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT p.ID FROM partido p
        JOIN jugador j ON j.Equipo_ID = p.Equipo_Local_ID OR j.Equipo_ID = p.Equipo_Visitante_ID
        WHERE j.ID = %s AND p.ID_jornada = %s AND p.ID_categoria = j.Categoria_ID
    """, (jugador_id, jornada))
    partido = cur.fetchone()
    
    if partido:
        partido_id = partido['ID']
    else:
        partido_id = None

    # Registrar o actualizar las estadísticas del jugador
    cur.execute("""
        INSERT INTO goles_jugador (Jugador_ID, Jornada, Goles, Tarjetas_Amarillas, Tarjetas_Rojas, Sanciones, Partido_ID)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE 
            Goles = VALUES(Goles),
            Tarjetas_Amarillas = VALUES(Tarjetas_Amarillas),
            Tarjetas_Rojas = VALUES(Tarjetas_Rojas),
            Sanciones = VALUES(Sanciones),
            Partido_ID = VALUES(Partido_ID)
    """, (jugador_id, jornada, goles, amarillas, rojas, sanciones, partido_id))
    mysql.connection.commit()
    cur.close()

    return '', 200




######################################################################################################################
@app.route('/actualizar-estadisticas', methods=["POST"])
def actualizar_estadisticas():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        tipo = request.form['tipo']  # 'goles', 'amarillas' o 'rojas'
        accion = request.form['accion']  # 'aumentar' o 'disminuir'

        # Realiza las operaciones de actualización en la base de datos
        cur = mysql.connection.cursor()

        if accion == 'aumentar':
            if tipo == 'goles':
                cur.execute("""
                    UPDATE est_jugador_c 
                    SET Goles_Anotados = Goles_Anotados + 1 
                    WHERE Jugador_ID IN (
                        SELECT ID FROM jugador 
                        WHERE Nombre = %s AND Apellido_Paterno = %s AND Apellido_Materno = %s
                    )
                """, (nombre, apellido_paterno, apellido_materno))
            elif tipo == 'amarillas':
                cur.execute("""
                    UPDATE est_jugador_c 
                    SET Tarjetas_Amarillas = Tarjetas_Amarillas + 1 
                    WHERE Jugador_ID IN (
                        SELECT ID FROM jugador 
                        WHERE Nombre = %s AND Apellido_Paterno = %s AND Apellido_Materno = %s
                    )
                """, (nombre, apellido_paterno, apellido_materno))
            elif tipo == 'rojas':
                cur.execute("""
                    UPDATE est_jugador_c 
                    SET Tarjetas_Rojas = Tarjetas_Rojas + 1 
                    WHERE Jugador_ID IN (
                        SELECT ID FROM jugador 
                        WHERE Nombre = %s AND Apellido_Paterno = %s AND Apellido_Materno = %s
                    )
                """, (nombre, apellido_paterno, apellido_materno))
        elif accion == 'disminuir':
            if tipo == 'goles':
                cur.execute("""
                    UPDATE est_jugador_c 
                    SET Goles_Anotados = Goles_Anotados - 1 
                    WHERE Jugador_ID IN (
                        SELECT ID FROM jugador 
                        WHERE Nombre = %s AND Apellido_Paterno = %s AND Apellido_Materno = %s
                    ) AND Goles_Anotados > 0
                """, (nombre, apellido_paterno, apellido_materno))
            elif tipo == 'amarillas':
                cur.execute("""
                    UPDATE est_jugador_c 
                    SET Tarjetas_Amarillas = Tarjetas_Amarillas - 1 
                    WHERE Jugador_ID IN (
                        SELECT ID FROM jugador 
                        WHERE Nombre = %s AND Apellido_Paterno = %s AND Apellido_Materno = %s
                    ) AND Tarjetas_Amarillas > 0
                """, (nombre, apellido_paterno, apellido_materno))
            elif tipo == 'rojas':
                cur.execute("""
                    UPDATE est_jugador_c 
                    SET Tarjetas_Rojas = Tarjetas_Rojas - 1 
                    WHERE Jugador_ID IN (
                        SELECT ID FROM jugador 
                        WHERE Nombre = %s AND Apellido_Paterno = %s AND Apellido_Materno = %s
                    ) AND Tarjetas_Rojas > 0
                """, (nombre, apellido_paterno, apellido_materno))
        
        mysql.connection.commit()
        cur.close()

        return 'OK', 200
    return 'Error', 400

#########################################

@app.route('/calendario')
def calendario():
    return render_template('galeria.html')  

@app.route('/galeria')
def galeria():
    return render_template('galeria_fotos.html') 

@app.route('/noticias')
def noticias():
    return render_template('noticias.html') 

@app.route('/acceso-login', methods=["GET", "POST"])
def login():
    if request.method == 'POST' and 'txtCorreo' in request.form and 'txtPassword' in request.form:
        _correo = request.form['txtCorreo']
        _password = request.form['txtPassword']

        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM usuarios WHERE correo = %s AND password = %s', (_correo, _password,))
        account = cur.fetchone()

        if account:
            session['logueado'] = True
            session['id'] = account['id']
            session['id_rol'] = account['id_rol']

            if session['id_rol'] == 1:
                return render_template("admin.html")
            elif session['id_rol'] == 2:
                return render_template("usuario.html")
        else:
            return render_template('InicioSesión.html', mensaje="Usuario O Contraseña Incorrectas")

    # Si la solicitud no es POST, devolver la plantilla del formulario de inicio de sesión
    return render_template('InicioSesión.html')

@app.route('/registro')
def registro():
    return render_template('registro.html')  

from datetime import datetime

@app.route('/crear-registro', methods=["POST"])
def crear_registro(): 
    nombre = request.form['nombre']
    apellido_paterno = request.form['apellido_paterno']
    apellido_materno = request.form['apellido_materno']
    rut = request.form.get('rut', '')  # Obtener el valor del rut o una cadena vacía si no está presente
    fecha_nacimiento = datetime.strptime(request.form['fecha_nacimiento'], '%Y-%m-%d').date()  # Convertir a objeto datetime
    categoria_id = int(request.form['categoria_id'])  # Convertir a entero para facilitar la validación
    equipo_id = request.form['equipo_id']
    
    if rut.strip() == '':
        # El rut está vacío, muestra un mensaje de error o realiza alguna otra acción apropiada
        return render_template('registro.html', mensaje="El campo Rut es obligatorio")

    # Validar que categoria_id esté entre 1 y 5
    if categoria_id < 1 or categoria_id > 5:
        return render_template('registro.html', mensaje="El valor de categoria_id debe estar entre 1 y 5")

    # Calcular la edad del jugador
    edad = datetime.now().year - fecha_nacimiento.year - ((datetime.now().month, datetime.now().day) < (fecha_nacimiento.month, fecha_nacimiento.day))

    # Definir rangos de edad para cada categoría
    rangos_edad = {
        1: (0, 17),   # Juvenil: hasta 17 años
        2: (18, 34),  # Adulta: de 18 a 34 años
        3: (35, 44),  # Senior: de 35 a 44 años
        4: (45, 150), # Super Senior: desde 45 años en adelante
        5: (0, 150)   # Honor: cualquier edad
    }

    # Verificar si la edad está dentro del rango permitido para la categoría seleccionada
    rango_categoria = rangos_edad.get(categoria_id)
    if not rango_categoria or not (rango_categoria[0] <= edad <= rango_categoria[1]):
        return render_template('registro.html', mensaje=f"La edad ({edad} años) no corresponde a la categoría seleccionada")

    try:
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO jugador (Nombre, Fecha_Nacimiento, Categoria_ID, Equipo_ID, Rut, Apellido_Paterno, Apellido_Materno) VALUES (%s, %s, %s, %s, %s, %s, %s)", (nombre, fecha_nacimiento, categoria_id, equipo_id, rut, apellido_paterno, apellido_materno))
        mysql.connection.commit()
    except mysql.connection.IntegrityError as e:
        # Manejar el error de integridad (por ejemplo, rut duplicado)
        return render_template('registro.html', mensaje="Error: El Rut ya está en uso")

    return redirect(url_for('listar_jugadores'))


@app.route('/admin-enfrentamientos', methods=['GET', 'POST'])
def administrar_enfrentamientos():
    if request.method == 'POST':
        try:
            if 'id_partido' in request.form:
                # Actualizar resultados del partido existente
                id_partido = request.form['id_partido']
                goles_local = int(request.form['goles_local'])
                goles_visitante = int(request.form['goles_visitante'])

                # Actualizar los resultados en la base de datos
                cur = mysql.connection.cursor()
                cur.execute("""
                    UPDATE partido
                    SET Goles_Local = %s, Goles_Visita = %s
                    WHERE ID = %s
                """, (goles_local, goles_visitante, id_partido))
                mysql.connection.commit()

                # Obtener el ID de los equipos y la categoría del partido
                cur.execute("""
                    SELECT Equipo_Local_ID, Equipo_Visitante_ID, ID_categoria
                    FROM partido
                    WHERE ID = %s
                """, (id_partido,))
                partido = cur.fetchone()

                equipo_local_id = partido['Equipo_Local_ID']
                equipo_visitante_id = partido['Equipo_Visitante_ID']
                id_categoria = partido['ID_categoria']

                # Actualizar la tabla de posiciones y el torneo regular
                actualizar_tabla_posiciones(equipo_local_id, equipo_visitante_id, goles_local, goles_visitante, id_categoria)
                actualizar_torneo_regular()

                cur.close()

                flash('Resultados del partido actualizados correctamente.', 'success')

            else:
                # Crear nuevo enfrentamiento
                equipo_local_id = request.form['equipo_local_id']
                equipo_visitante_id = request.form['equipo_visitante_id']
                id_categoria = request.form['id_categoria']
                id_jornada = request.form['id_jornada']
                ubicacion = request.form['ubicacion']
                fecha = request.form['fecha']

                # Verificar si ya existe un enfrentamiento con los mismos equipos, jornada y categoría
                cur = mysql.connection.cursor()
                cur.execute("""
                    SELECT * FROM partido
                    WHERE Equipo_Local_ID = %s AND Equipo_Visitante_ID = %s AND ID_jornada = %s AND ID_categoria = %s
                """, (equipo_local_id, equipo_visitante_id, id_jornada, id_categoria))
                resultado = cur.fetchone()

                if resultado:
                    flash('El enfrentamiento ya existe.', 'error')
                else:
                    # Insertar el nuevo enfrentamiento en la base de datos
                    cur.execute("""
                        INSERT INTO partido (Equipo_Local_ID, Equipo_Visitante_ID, ID_categoria, ID_jornada, Ubicacion, Fecha)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (equipo_local_id, equipo_visitante_id, id_categoria, id_jornada, ubicacion, fecha))
                    mysql.connection.commit()

                    flash('Enfrentamiento registrado correctamente.', 'success')

                # Actualizar la tabla de posiciones y el torneo regular
                actualizar_tabla_posiciones(equipo_local_id, equipo_visitante_id, 0, 0, id_categoria)
                actualizar_torneo_regular()

                cur.close()

            return redirect(url_for('administrar_enfrentamientos'))

        except Exception as e:
            # Captura de errores generales para evitar errores 500
            flash(f'Ocurrió un error: {str(e)}', 'error')
            return redirect(url_for('administrar_enfrentamientos'))
    else:
        # Consultar las jornadas disponibles
        cur = mysql.connection.cursor()
        cur.execute("SELECT ID, Nombre FROM jornada")
        jornadas = cur.fetchall()

        # Consultar los equipos disponibles
        cur.execute("SELECT ID, Nombre FROM equipo")
        equipos = cur.fetchall()

        # Consultar las categorías disponibles
        cur.execute("SELECT ID, Nombre FROM categoria")
        categorias = cur.fetchall()

        # Obtener el parámetro de filtrado por jornada
        id_jornada_filtro = request.args.get('jornada')

        # Consultar los enfrentamientos programados
        if id_jornada_filtro:
            cur.execute("""
                SELECT p.ID, p.Fecha, j.Nombre AS Nombre_Jornada, p.Ubicacion, e1.Nombre AS Equipo_Local, e2.Nombre AS Equipo_Visitante, c.Nombre AS Categoria, p.Goles_Local, p.Goles_Visita
                FROM partido p
                JOIN equipo e1 ON p.Equipo_Local_ID = e1.ID
                JOIN equipo e2 ON p.Equipo_Visitante_ID = e2.ID
                JOIN categoria c ON p.ID_categoria = c.ID
                JOIN jornada j ON p.ID_jornada = j.ID
                WHERE p.ID_jornada = %s
            """, (id_jornada_filtro,))
        else:
            cur.execute("""
                SELECT p.ID, p.Fecha, j.Nombre AS Nombre_Jornada, p.Ubicacion, e1.Nombre AS Equipo_Local, e2.Nombre AS Equipo_Visitante, c.Nombre AS Categoria, p.Goles_Local, p.Goles_Visita
                FROM partido p
                JOIN equipo e1 ON p.Equipo_Local_ID = e1.ID
                JOIN equipo e2 ON p.Equipo_Visitante_ID = e2.ID
                JOIN categoria c ON p.ID_categoria = c.ID
                JOIN jornada j ON p.ID_jornada = j.ID
            """)
        enfrentamientos = cur.fetchall()

        cur.close()

        return render_template('admin_enfrentamientos.html', enfrentamientos=enfrentamientos, jornadas=jornadas, equipos=equipos, categorias=categorias)

##############################################################################################################
@app.route('/realizar-traspaso', methods=["POST"])
def realizar_traspaso():
    jugador_id = request.form['jugador_id']
    equipo_destino_id = request.form['equipo_destino_id']
    
    # Obtener los datos del jugador
    cur = mysql.connection.cursor()
    cur.execute("SELECT Nombre, Apellido_Paterno, Apellido_Materno, Equipo_ID FROM jugador WHERE ID = %s", (jugador_id,))
    jugador = cur.fetchone()

    if not jugador:
        return "Jugador no encontrado"
    
    # Actualizar el equipo del jugador en la base de datos
    cur.execute("UPDATE jugador SET Equipo_ID = %s WHERE ID = %s", (equipo_destino_id, jugador_id))
    mysql.connection.commit()

    # Obtener el nombre del equipo destino
    cur.execute("SELECT Nombre FROM equipo WHERE ID = %s", (equipo_destino_id,))
    equipo_destino = cur.fetchone()

    # Renderizar la plantilla de confirmación de traspaso
    return render_template('traspaso_confirmacion.html', jugador=jugador, equipo_destino=equipo_destino)





@app.route('/transferir-jugador', methods=["GET", "POST"])
def transferir_jugador():
    if request.method == "POST":
        rut_jugador = request.form['rut_jugador']
        nuevo_equipo_id = request.form['nuevo_equipo_id']

        try:
            cur = mysql.connection.cursor()
            cur.execute("UPDATE jugador SET Equipo_ID = %s WHERE Rut = %s", (nuevo_equipo_id, rut_jugador))
            mysql.connection.commit()
            flash('El jugador ha sido transferido exitosamente!')
        except mysql.connection.IntegrityError as e:
            flash("Error: El RUT del jugador no existe o el ID del equipo no existe")
            return render_template('transferir.html')

        return redirect(url_for('transferir_jugador'))
    else:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM equipo")
        equipos = cur.fetchall()
        return render_template('transferir.html', equipos=equipos)



from flask import jsonify

@app.route('/obtener-jugador-por-rut', methods=["GET"])
def obtener_jugador_por_rut():
    rut_jugador = request.args.get('rut_jugador')

    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM jugador WHERE Rut = %s", (rut_jugador,))
        jugador = cur.fetchone()
        if jugador is not None:
            # Formatear la fecha de nacimiento
            jugador['Fecha_Nacimiento'] = jugador['Fecha_Nacimiento'].strftime('%Y-%m-%d')
            cur.execute("SELECT Nombre FROM equipo WHERE ID = %s", (jugador['Equipo_ID'],))
            equipo = cur.fetchone()
            if equipo is not None:
                jugador['Equipo_ID'] = equipo['Nombre']
    except mysql.connection.IntegrityError as e:
        return jsonify(error=str(e)), 400

    if jugador is None:
        return jsonify(error="No se encontró un jugador con ese RUT"), 404

    return jsonify(jugador)








##################################################################################################

######################################################
#############Descargar formularios####################
from flask import send_from_directory

@app.route('/descargar-reglamento')
def descargar_reglamento():
    return send_from_directory('documents', 'REGLAMENTO.docx', as_attachment=True)


@app.route('/formulario')
def formulario():
    return render_template('formularios.html')


# Ruta para listar jugadores
@app.route('/listar-jugadores')
def listar_jugadores(): 
    cur = mysql.connection.cursor()
    cur.execute("SELECT jugador.*, equipo.Nombre AS NombreEquipo FROM jugador LEFT JOIN equipo ON jugador.Equipo_ID = equipo.ID")
    jugadores = cur.fetchall()

    # Obtener los equipos y categorías para mostrar en la tabla
    cur.execute("SELECT * FROM equipo")
    equipos = cur.fetchall()

    cur.execute("SELECT * FROM categoria")
    categorias = cur.fetchall()

    cur.close()

    return render_template("listar_jugadores.html", jugadores=jugadores, equipos=equipos, categorias=categorias)





# Ruta para listar equipos
@app.route('/listar-equipos')
def listar_equipos():
    cur = mysql.connection.cursor()
    # Realizar un JOIN entre las tablas equipo y division
    cur.execute("""
        SELECT equipo.ID, equipo.Nombre, equipo.Ciudad, equipo.Imagen, division.Nombre AS Division_Nombre
        FROM equipo
        JOIN division ON equipo.Division_ID = division.ID
    """)
    equipos = cur.fetchall()
    cur.close()

    # Asegurarse de que cada equipo tenga la ruta completa de la imagen
    for equipo in equipos:
        equipo['Imagen'] = f"/static/images/equipos/{equipo['Imagen']}"

    return render_template("listar_equipos.html", equipos=equipos)





@app.route('/equipo/<int:id>')
def obtener_equipo(id):
    cur = mysql.connection.cursor()
    
    # Obtener información del equipo
    cur.execute("SELECT * FROM equipo WHERE id = %s", (id,))
    equipo = cur.fetchone()

    if not equipo:
        # Si no se encuentra el equipo, devuelve un mensaje de error y un código de estado 404
        return jsonify({"error": "Equipo no encontrado"}), 404

    # Obtener el parámetro de consulta 'categoria'
    categoria = request.args.get('categoria')
    
    # Consulta para obtener los datos de la tabla categoria
    cur.execute("SELECT * FROM categoria")
    categorias = cur.fetchall()

    # Definir la consulta base para obtener jugadores con JOIN para obtener el nombre de la categoría y las estadísticas
    consulta_jugadores = """
        SELECT 
            j.ID, 
            j.Nombre, 
            j.Apellido_Paterno, 
            j.Apellido_Materno, 
            j.Rut, 
            j.Fecha_Nacimiento, 
            j.Categoria_ID, 
            c.Nombre AS Categoria,
            COALESCE(SUM(g.Goles), 0) AS Goles_Anotados, 
            COALESCE(SUM(g.Tarjetas_Amarillas), 0) AS Tarjetas_Amarillas, 
            COALESCE(SUM(g.Tarjetas_Rojas), 0) AS Tarjetas_Rojas, 
            COALESCE(ROUND(a.Asistencia), 0) AS Asistencia 
        FROM 
            jugador j 
            LEFT JOIN categoria c ON j.Categoria_ID = c.ID
            LEFT JOIN goles_jugador g ON j.ID = g.Jugador_ID 
            LEFT JOIN (
                SELECT 
                    id_jugador, 
                    SUM(asistencia)/18*100 AS Asistencia 
                FROM 
                    asistencia 
                GROUP BY 
                    id_jugador
            ) a ON j.ID = a.id_jugador
        WHERE 
            j.Equipo_ID = %s
    """
    
    params = [id]
    
    # Si se proporciona la categoría, ajusta la consulta para filtrar jugadores por esa categoría
    if categoria:
        consulta_jugadores += " AND j.Categoria_ID = %s"
        params.append(categoria)
    
    consulta_jugadores += " GROUP BY j.ID, c.Nombre"
    
    cur.execute(consulta_jugadores, params)
    jugadores = cur.fetchall()
    cur.close()

    # Renderiza la plantilla HTML correspondiente al equipo y pasa la información del equipo, jugadores, categorías y equipo_id
    return render_template(f"equipos/equipo{id}.html", equipo=equipo, jugadores=jugadores, equipo_id=id, categorias=categorias, categoria=categoria)



@app.route('/jugador/<int:id>')
def obtener_jugador(id):
    cur = mysql.connection.cursor()
    
    # Obtener información del jugador
    cur.execute("SELECT * FROM jugador WHERE ID = %s", (id,))
    jugador = cur.fetchone()

    if not jugador:
        cur.close()
        return jsonify({"error": "Jugador no encontrado"}), 404

    # Obtener el equipo del jugador
    cur.execute("SELECT * FROM equipo WHERE ID = %s", (jugador['Equipo_ID'],))
    equipo = cur.fetchone()

    # Obtener el nombre de la categoría del jugador
    cur.execute("SELECT Nombre FROM categoria WHERE ID = %s", (jugador['Categoria_ID'],))
    categoria = cur.fetchone()

    # Obtener estadísticas del jugador
    cur.execute("""
        SELECT 
            COALESCE(SUM(Goles), 0) AS Goles_Anotados, 
            COALESCE(SUM(Tarjetas_Amarillas), 0) AS Tarjetas_Amarillas, 
            COALESCE(SUM(Tarjetas_Rojas), 0) AS Tarjetas_Rojas 
        FROM goles_jugador 
        WHERE Jugador_ID = %s
    """, (id,))
    estadisticas = cur.fetchone()

    cur.close()

    # Renderizar la plantilla HTML y pasar los datos del jugador, equipo, categoría y estadísticas
    return render_template("detallesjugadores.html", jugador=jugador, equipo=equipo, categoria=categoria, estadisticas=estadisticas)




# estadisticas jugadores
@app.route('/estadisticas-jugadores')
def estadisticas_jugadores():
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT 
            j.Nombre, 
            j.Apellido_Paterno, 
            j.Apellido_Materno, 
            COALESCE(SUM(g.Goles), 0) AS Goles_Anotados, 
            COALESCE(SUM(g.Tarjetas_Amarillas), 0) AS Tarjetas_Amarillas, 
            COALESCE(SUM(g.Tarjetas_Rojas), 0) AS Tarjetas_Rojas, 
            COALESCE(ROUND(a.Asistencia), 0) AS Asistencia 
        FROM 
            jugador j 
            LEFT JOIN goles_jugador g ON j.ID = g.Jugador_ID 
            LEFT JOIN (
                SELECT 
                    id_jugador, 
                    SUM(asistencia)/18*100 AS Asistencia 
                FROM 
                    asistencia 
                GROUP BY 
                    id_jugador
            ) a ON j.ID = a.id_jugador
        GROUP BY 
            j.ID
    """)
    jugadores = cur.fetchall()
    cur.close()

    if jugadores:
        return render_template("estadisticas_jugadores.html", jugadores=jugadores)
    else:
        return jsonify({"error": "No se encontraron jugadores"}), 404




# Ruta para mostrar los resultados de los partidos
from flask import Flask, render_template, request
from flask_mysqldb import MySQL
from collections import defaultdict

# Ruta para mostrar los resultados de los partidos
@app.route('/partidos', methods=['GET', 'POST'])
def resultados_partidos():
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        ID_jornada = request.form.get('ID_jornada', 1)
    else:
        ID_jornada = 1

    cur.execute("""
        SELECT p.Goles_Local, p.Goles_Visita, p.Ubicacion, p.Fecha, e1.Nombre AS Equipo_Local, e2.Nombre AS Equipo_Visitante, c.Nombre AS Nombre_Categoria, p.ID AS Partido_ID
        FROM partido p
        JOIN equipo e1 ON p.Equipo_Local_ID = e1.ID
        JOIN equipo e2 ON p.Equipo_Visitante_ID = e2.ID
        JOIN categoria c ON p.ID_categoria = c.ID
        WHERE p.ID_jornada = %s
    """, (ID_jornada,))
    partidos = cur.fetchall()

    cur.execute("""
        SELECT gj.Partido_ID, j.Nombre, j.Apellido_Paterno, j.Apellido_Materno, gj.Goles, e.Nombre AS Nombre_Equipo
        FROM goles_jugador gj
        INNER JOIN jugador j ON gj.Jugador_ID = j.ID
        INNER JOIN equipo e ON j.Equipo_ID = e.ID
        WHERE gj.Jornada = %s
    """, (ID_jornada,))
    goles_por_partido = cur.fetchall()

    categorias = defaultdict(list)
    for partido in partidos:
        categoria_nombre = partido['Nombre_Categoria']
        partido_info = {
            'Equipo_Local': partido['Equipo_Local'],
            'Goles_Local': partido['Goles_Local'],
            'Goles_Visita': partido['Goles_Visita'],
            'Equipo_Visitante': partido['Equipo_Visitante'],
            'Ubicacion': partido['Ubicacion'],
            'Fecha': partido['Fecha'],
            'Partido_ID': partido['Partido_ID'],
            'Jugadores': []
        }
        for gol in goles_por_partido:
            if gol['Partido_ID'] == partido['Partido_ID']:
                jugador_info = {
                    'Nombre': f"{gol['Nombre']} {gol['Apellido_Paterno']} {gol['Apellido_Materno']}",
                    'Goles': gol['Goles'],
                    'Equipo': gol['Nombre_Equipo']
                }
                partido_info['Jugadores'].append(jugador_info)

        categorias[categoria_nombre].append(partido_info)

    categorias = dict(categorias)
    return render_template("resultados_partidos.html", categorias=categorias, ID_jornada=int(ID_jornada))

##################################################################################

# Ruta para obtener los goles de jugadores por jornada
@app.route('/administrar_goles', methods=['GET', 'POST'])
def administrar_goles():
    if request.method == 'POST':
        ID_jornada = request.form['ID_jornada']
        ID_categoria = request.form['ID_categoria']

        cur = mysql.connection.cursor()

        # Consultar todos los enfrentamientos de la jornada y categoría seleccionadas
        cur.execute("""
            SELECT p.Equipo_Local_ID, p.Equipo_Visitante_ID, p.ID_jornada, p.ID_categoria, 
                   e1.Nombre AS Nombre_Local, e2.Nombre AS Nombre_Visitante
            FROM partido p
            JOIN equipo e1 ON p.Equipo_Local_ID = e1.ID
            JOIN equipo e2 ON p.Equipo_Visitante_ID = e2.ID
            WHERE p.ID_jornada = %s AND p.ID_categoria = %s
        """, (ID_jornada, ID_categoria))
        enfrentamientos = cur.fetchall()

        # Lista para almacenar los jugadores del equipo local de cada enfrentamiento
        jugadores_locales = []

        # Lista para almacenar los jugadores del equipo visitante de cada enfrentamiento
        jugadores_visitantes = []

        # Consultar los jugadores de cada equipo para cada enfrentamiento
        for enfrentamiento in enfrentamientos:
            # Consultar los jugadores del equipo local para el enfrentamiento actual
            cur.execute("""
                SELECT j.ID, j.Nombre
                FROM jugador j
                JOIN equipo e ON j.Equipo_ID = e.ID
                WHERE e.ID = %s AND e.Categoria_ID = %s
            """, (enfrentamiento['Equipo_Local_ID'], ID_categoria))
            jugadores_local = cur.fetchall()
            jugadores_locales.append(jugadores_local)

            # Consultar los jugadores del equipo visitante para el enfrentamiento actual
            cur.execute("""
                SELECT j.ID, j.Nombre
                FROM jugador j
                JOIN equipo e ON j.Equipo_ID = e.ID
                WHERE e.ID = %s AND e.Categoria_ID = %s
            """, (enfrentamiento['Equipo_Visitante_ID'], ID_categoria))
            jugadores_visitante = cur.fetchall()
            jugadores_visitantes.append(jugadores_visitante)

        cur.close()

        return render_template("administrar_goles.html", enfrentamientos=enfrentamientos, jugadores_locales=jugadores_locales, jugadores_visitantes=jugadores_visitantes)

    else:
        cur = mysql.connection.cursor()

        # Consultar todas las jornadas disponibles
        cur.execute("SELECT ID, Nombre FROM jornada")
        jornadas = cur.fetchall()

        # Consultar todas las categorías disponibles
        cur.execute("SELECT ID, Nombre FROM categoria")
        categorias = cur.fetchall()

        cur.close()

        return render_template("formulario_administrar_goles.html", jornadas=jornadas, categorias=categorias)


@app.route('/guardar_goles', methods=['POST'])
def guardar_goles():
    if request.method == 'POST':
        # Obtener los datos enviados desde el formulario
        equipo_local_id = request.form['equipo_local_id']
        equipo_visitante_id = request.form['equipo_visitante_id']
        jornada_id = request.form['jornada_id']
        categoria_id = request.form['categoria_id']
        
        # Crear una conexión a la base de datos
        cur = mysql.connection.cursor()

        # Iterar sobre los datos de los goles marcados por los jugadores del equipo local
        for jugador_id, goles in request.form.items():
            if jugador_id.startswith('goles_local_'):
                jugador_id = jugador_id.replace('goles_local_', '')  # Obtener el ID del jugador
                # Insertar los goles del jugador en la tabla correspondiente de la base de datos
                cur.execute("""
                    INSERT INTO goles_jornada (ID_jugador, ID_jornada, goles)
                    VALUES (%s, %s, %s)
                """, (jugador_id, jornada_id, goles))

        # Iterar sobre los datos de los goles marcados por los jugadores del equipo visitante
        for jugador_id, goles in request.form.items():
            if jugador_id.startswith('goles_visitante_'):
                jugador_id = jugador_id.replace('goles_visitante_', '')  # Obtener el ID del jugador
                # Insertar los goles del jugador en la tabla correspondiente de la base de datos
                cur.execute("""
                    INSERT INTO goles_jornada (ID_jugador, ID_jornada, goles)
                    VALUES (%s, %s, %s)
                """, (jugador_id, jornada_id, goles))

        # Commit para guardar los cambios en la base de datos
        mysql.connection.commit()
        
        # Cerrar la conexión a la base de datos
        cur.close()

        # Redireccionar a la página de administrar goles
        return redirect(url_for('administrar_goles'))

    # En caso de que no se haya enviado una solicitud POST, redirigir a la página de administrar goles
    else:
        return redirect(url_for('administrar_goles'))


#########################################################################################################################

# Ruta para obtener los datos de los jugadores y sus estadísticas
@app.route('/asistencia-jugadores')
def mostrar_jugadores():
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, nombre, Apellido_Paterno, Apellido_Materno FROM jugador")

    jugadores = cur.fetchall()

    # Obtener la lista de todas las jornadas disponibles
    cur.execute("SELECT DISTINCT jornada FROM asistencia")
    jornadas = [res['jornada'] for res in cur.fetchall()]
    jornadas.sort()  # Ordenar las jornadas

    asistencia_jornadas = {}
    total_jornadas_asistidas = {}
    total_asistencias_por_jornada = {f'J{j}': 0 for j in jornadas}
    asistencia_total = {}  

    # Obtener la asistencia de cada jugador para cada jornada
    for jugador in jugadores:
        cur.execute("SELECT jornada, SUM(asistencia) AS total FROM asistencia WHERE id_jugador = %s GROUP BY jornada", (jugador['id'],))
        asistencia_result = cur.fetchall()

        # Crear un diccionario para mantener la asistencia del jugador por jornada
        jugador_asistencia = {res['jornada']: res['total'] for res in asistencia_result}

        # Calcular el total de asistencias para el jugador, manejando posibles valores None
        total_asistencias = sum(res['total'] if res['total'] is not None else 0 for res in asistencia_result)
        asistencia_total[jugador['id']] = total_asistencias

        # Actualizar el total de asistencias por jornada para todos los jugadores
        for jornada in jornadas:
            total_asistencias_por_jornada[f'J{jornada}'] += jugador_asistencia.get(jornada, 0) or 0

        # Actualizar la asistencia del jugador para todas las jornadas
        asistencia_jornadas[jugador['id']] = jugador_asistencia
        total_jornadas_asistidas[jugador['id']] = total_asistencias

    cur.close()

    total_asistencia_partidos = sum(total_asistencias_por_jornada.values())
    # Calcular el total de asistencias posibles (18 jornadas)
    total_asistencias_posibles = 18

    return render_template('asistencia.html', jugadores=jugadores, asistencia_jornadas=asistencia_jornadas, total_jornadas_asistidas=total_jornadas_asistidas, total_asistencias_por_jornada=total_asistencias_por_jornada, asistencia_total=asistencia_total, jornadas=jornadas, total_asistencia_partidos=total_asistencia_partidos, total_asistencias_posibles=total_asistencias_posibles)

#########################################################################################################################


@app.route('/actualizar-asistencia', methods=['POST'])
def actualizar_asistencia():
    id_jugador = request.form.get('id_jugador')
    jornada = request.form.get('jornada')
    asistencia = request.form.get('asistencia')

    cur = mysql.connection.cursor()
    cur.execute("""
        INSERT INTO asistencia (id_jugador, jornada, asistencia)
        VALUES (%s, %s, %s)
        ON DUPLICATE KEY UPDATE asistencia = %s
        """, (id_jugador, jornada, asistencia, asistencia))
    mysql.connection.commit()
    cur.close()

    return jsonify({'status': 'success'})

@app.route('/asistencia-jugadores_admin', methods=['GET', 'POST'])
def mostrar_jugadores_admin():
    cur = mysql.connection.cursor()

    # Obtener equipos y categorías
    cur.execute("SELECT id, nombre FROM equipo")
    equipos = cur.fetchall()
    cur.execute("SELECT id, nombre FROM categoria")
    categorias = cur.fetchall()

    equipo_id = request.form.get('equipo_id')
    categoria_id = request.form.get('categoria_id')
    jornada_seleccionada = request.form.get('jornada')

    jugadores = []
    asistencia_jornadas = {}
    asistencia_total = {}
    total_asistencias_posibles = 0
    total_asistencias_por_jornada = {}

    if equipo_id and categoria_id and jornada_seleccionada:
        # Filtrar jugadores por equipo y categoría
        cur.execute("SELECT id, nombre, Apellido_Paterno, Apellido_Materno FROM jugador WHERE equipo_id = %s AND categoria_id = %s", (equipo_id, categoria_id))
        jugadores = cur.fetchall()

        jornada_seleccionada = int(jornada_seleccionada)

        for jugador in jugadores:
            cur.execute("SELECT asistencia FROM asistencia WHERE id_jugador = %s AND jornada = %s", (jugador['id'], jornada_seleccionada))
            asistencia = cur.fetchone()
            asistencia_jornadas[jugador['id']] = {jornada_seleccionada: asistencia['asistencia'] if asistencia and asistencia['asistencia'] is not None else 0}
            asistencia_total[jugador['id']] = asistencia_jornadas[jugador['id']][jornada_seleccionada]

        # Asegurarse de que los valores sean enteros y reemplazar None por 0
        asistencia_total = {key: (valor if valor is not None else 0) for key, valor in asistencia_total.items()}
        
        # Sumar los valores
        total_asistencias_por_jornada[f'J{jornada_seleccionada}'] = sum(asistencia_total.values())
        total_asistencias_posibles = len(jugadores) * jornada_seleccionada  # Asumiendo que cada jugador debe asistir a cada jornada

    cur.close()
    return render_template('admin_asistencia.html', 
                           equipos=equipos, 
                           categorias=categorias, 
                           jugadores=jugadores, 
                           asistencia_jornadas=asistencia_jornadas, 
                           total_asistencias_por_jornada=total_asistencias_por_jornada, 
                           asistencia_total=asistencia_total, 
                           jornada_seleccionada=jornada_seleccionada if equipo_id and categoria_id and jornada_seleccionada else None, 
                           total_asistencias_posibles=total_asistencias_posibles)

@app.route('/actualizar_asist', methods=['POST'])
def actualizar_asist():
    id_jugador = request.form.get('id_jugador')
    jornada = request.form.get('jornada')
    asistencia = request.form.get('asistencia')

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO asistencia (id_jugador, jornada, asistencia) VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE asistencia = VALUES(asistencia)", (id_jugador, jornada, asistencia))
    mysql.connection.commit()
    cur.close()
    return '', 204  # Sin contenido

########### TABLAS DE POSICIONES ############
#############################################
#############################################
#############################################

def actualizar_tabla_posiciones(equipo_local_id, equipo_visitante_id, goles_local, goles_visitante, id_categoria):
    # Determinar la tabla de posiciones a actualizar según la categoría
    tabla_posiciones = f'tabla_{id_categoria}_p'

    cur = mysql.connection.cursor()

    # Actualizar los goles a favor y en contra
    cur.execute(f"""
        UPDATE {tabla_posiciones}
        SET Goles_Favor = Goles_Favor + %s, Goles_Contra = Goles_Contra + %s
        WHERE Equipo_ID = %s
    """, (goles_local, goles_visitante, equipo_local_id))
    cur.execute(f"""
        UPDATE {tabla_posiciones}
        SET Goles_Favor = Goles_Favor + %s, Goles_Contra = Goles_Contra + %s
        WHERE Equipo_ID = %s
    """, (goles_visitante, goles_local, equipo_visitante_id))

    # Actualizar partidos jugados, ganados, empatados y perdidos
    cur.execute(f"""
        UPDATE {tabla_posiciones}
        SET P_Jugados = P_Jugados + 1
        WHERE Equipo_ID = %s OR Equipo_ID = %s
    """, (equipo_local_id, equipo_visitante_id))

    if goles_local > goles_visitante:
        # El equipo local ganó
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET P_Ganados = P_Ganados + 1, Puntos = Puntos + 3
            WHERE Equipo_ID = %s
        """, (equipo_local_id,))
        # El equipo visitante perdió
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET P_Perdidos = P_Perdidos + 1
            WHERE Equipo_ID = %s
        """, (equipo_visitante_id,))
    elif goles_local < goles_visitante:
        # El equipo visitante ganó
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET P_Ganados = P_Ganados + 1, Puntos = Puntos + 3
            WHERE Equipo_ID = %s
        """, (equipo_visitante_id,))
        # El equipo local perdió
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET P_Perdidos = P_Perdidos + 1
            WHERE Equipo_ID = %s
        """, (equipo_local_id,))
    else:
        # Empate
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET P_Empatados = P_Empatados + 1, Puntos = Puntos + 1
            WHERE Equipo_ID = %s OR Equipo_ID = %s
        """, (equipo_local_id, equipo_visitante_id))

    mysql.connection.commit()
    cur.close()



# Muestra la tabla general de primera división
@app.route('/tabla-posiciones')
def tabla_posiciones():
    # Obtener la categoría seleccionada desde los parámetros de la URL
    categoria_seleccionada = request.args.get('categoria', 'all')

    # Determinar la tabla a consultar según la categoría seleccionada
    if categoria_seleccionada == 'all':
        tabla = 'torneo_regular'
    elif categoria_seleccionada in ['1', '2', '3', '4', '5']:
        tabla = f'tabla_{categoria_seleccionada}_p'
    else:
        return "Categoría no válida"

    # Conexión a la base de datos MySQL
    cur = mysql.connection.cursor()

    # Consulta SQL para obtener los datos de la tabla de posiciones
    cur.execute(f"""
        SELECT e.Nombre AS Club, e.Imagen AS Imagen, 
               SUM(COALESCE(tr.Puntos, 0)) AS PTS, 
               MAX(tr.P_Jugados) AS PJ, 
               MAX(tr.P_Ganados) AS PG, 
               MAX(tr.P_Empatados) AS PE, 
               MAX(tr.P_Perdidos) AS PP, 
               MAX(tr.Goles_Favor) AS GF, 
               MAX(tr.Goles_Contra) AS GC,
               MAX(tr.Goles_Favor - tr.Goles_Contra) AS DIF
        FROM {tabla} tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        GROUP BY e.Nombre, e.Imagen
        ORDER BY PTS DESC, DIF DESC
    """)

    tabla_posiciones = cur.fetchall()

    cur.close()

    # Asegurarse de que cada equipo tenga la ruta completa de la imagen
    for equipo in tabla_posiciones:
        equipo['Siglas'] = equipo['Club'][:3].upper()
        equipo['Imagen'] = f"/static/images/equipos/{equipo['Imagen']}"

    # Renderizar la plantilla HTML con los datos de la tabla de posiciones
    return render_template('tabla_posiciones.html', tabla_posiciones=tabla_posiciones)



def guardar_enfrentamiento(equipo_local_id, equipo_visitante_id, goles_local, goles_visita):
    try:
        cur = mysql.connection.cursor()

        # Lógica para guardar el enfrentamiento en la tabla 'partidos'
        cur.execute("""
            INSERT INTO partidos (Equipo_Local_ID, Equipo_Visitante_ID, Goles_local, Goles_visita)
            VALUES (%s, %s, %s, %s)
        """, (equipo_local_id, equipo_visitante_id, goles_local, goles_visita))
        mysql.connection.commit()

        # Después de guardar el enfrentamiento, actualizar la tabla 'torneo_regular'
        actualizar_torneo_regular()

        cur.close()

    except Exception as e:
        print(f"Error al guardar enfrentamiento: {e}")

def actualizar_torneo_regular():
    try:
        cur = mysql.connection.cursor()

        # Actualizar todas las estadísticas necesarias en la tabla torneo_regular
        cur.execute("""
            UPDATE torneo_regular AS tr
            JOIN (
                SELECT Equipo_ID,
                       COUNT(*) AS P_Jugados,
                       SUM(CASE WHEN Resultado = 'ganado' THEN 1 ELSE 0 END) AS P_Ganados,
                       SUM(CASE WHEN Resultado = 'empatado' THEN 1 ELSE 0 END) AS P_Empatados,
                       SUM(CASE WHEN Resultado = 'perdido' THEN 1 ELSE 0 END) AS P_Perdidos,
                       SUM(Goles_local) AS Goles_Favor,
                       SUM(Goles_visita) AS Goles_Contra
                FROM partidos
                GROUP BY Equipo_ID
            ) AS p ON tr.Equipo_ID = p.Equipo_ID
            SET tr.P_Jugados = p.P_Jugados,
                tr.P_Ganados = p.P_Ganados,
                tr.P_Empatados = p.P_Empatados,
                tr.P_Perdidos = p.P_Perdidos,
                tr.Goles_Favor = p.Goles_Favor,
                tr.Goles_Contra = p.Goles_Contra,
                tr.DIF = p.Goles_Favor - p.Goles_Contra
        """)
        mysql.connection.commit()

        cur.close()
    except Exception as e:
        print(f"Error al actualizar torneo regular: {e}")



def actualizar_tabla_posiciones(equipo_local_id, equipo_visitante_id, goles_local, goles_visitante, id_categoria):
    try:
        # Determinar la tabla de posiciones a actualizar según la categoría
        tabla_posiciones = f'tabla_{id_categoria}_p'

        cur = mysql.connection.cursor()

        # Actualizar los goles a favor y en contra
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET Goles_Favor = Goles_Favor + %s, Goles_Contra = Goles_Contra + %s
            WHERE Equipo_ID = %s
        """, (goles_local, goles_visitante, equipo_local_id))
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET Goles_Favor = Goles_Favor + %s, Goles_Contra = Goles_Contra + %s
            WHERE Equipo_ID = %s
        """, (goles_visitante, goles_local, equipo_visitante_id))

        # Actualizar partidos jugados, ganados, empatados y perdidos
        cur.execute(f"""
            UPDATE {tabla_posiciones}
            SET P_Jugados = P_Jugados + 1
            WHERE Equipo_ID = %s OR Equipo_ID = %s
        """, (equipo_local_id, equipo_visitante_id))

        if goles_local > goles_visitante:
            # El equipo local ganó
            cur.execute(f"""
                UPDATE {tabla_posiciones}
                SET P_Ganados = P_Ganados + 1, Puntos = Puntos + 3
                WHERE Equipo_ID = %s
            """, (equipo_local_id,))
            # El equipo visitante perdió
            cur.execute(f"""
                UPDATE {tabla_posiciones}
                SET P_Perdidos = P_Perdidos + 1
                WHERE Equipo_ID = %s
            """, (equipo_visitante_id,))
        elif goles_local < goles_visitante:
            # El equipo visitante ganó
            cur.execute(f"""
                UPDATE {tabla_posiciones}
                SET P_Ganados = P_Ganados + 1, Puntos = Puntos + 3
                WHERE Equipo_ID = %s
            """, (equipo_visitante_id,))
            # El equipo local perdió
            cur.execute(f"""
                UPDATE {tabla_posiciones}
                SET P_Perdidos = P_Perdidos + 1
                WHERE Equipo_ID = %s
            """, (equipo_local_id,))
        else:
            # Empate
            cur.execute(f"""
                UPDATE {tabla_posiciones}
                SET P_Empatados = P_Empatados + 1, Puntos = Puntos + 1
                WHERE Equipo_ID = %s OR Equipo_ID = %s
            """, (equipo_local_id, equipo_visitante_id))

        mysql.connection.commit()
        cur.close()

    except Exception as e:
        print(f"Error al actualizar tabla de posiciones: {e}")



def actualizar_puntos_torneo_regular():
    try:
        cur = mysql.connection.cursor()

        # Recorremos cada tabla de categoría
        for tabla_num in range(1, 6):
            tabla_name = f"tabla_{tabla_num}_p"

            # Consulta para sumar los puntos por equipo en la tabla actual
            cur.execute(f"""
                SELECT Equipo_ID, SUM(Puntos) AS Total_Puntos
                FROM {tabla_name}
                GROUP BY Equipo_ID
            """)
            puntos_por_equipo = cur.fetchall()

            # Actualizar la tabla torneo_regular con los puntos calculados
            for equipo_id, total_puntos in puntos_por_equipo:
                cur.execute("""
                    UPDATE torneo_regular
                    SET Puntos = COALESCE(Puntos, 0) + %s
                    WHERE Equipo_ID = %s
                """, (total_puntos, equipo_id))

        mysql.connection.commit()
        cur.close()

    except Exception as e:
        print(f"Error al actualizar puntos en torneo_regular: {e}")



##############################################################################################


# Muestra la tabla general de segunda división
@app.route('/tabla-posiciones-segunda', endpoint='tabla_posiciones_segunda')
def tabla_posiciones_segunda():
    # Obtener la categoría seleccionada desde los parámetros de la URL
    categoria_seleccionada = request.args.get('categoria', 'all')

    # Determinar la tabla a consultar según la categoría seleccionada
    if categoria_seleccionada == 'all':
        tabla = 'torneo_regular_segunda'
    elif categoria_seleccionada in ['1', '2', '3', '4', '5']:
        tabla = f'tabla_{categoria_seleccionada}_s'
    else:
        return "Categoría no válida"

    # Conexión a la base de datos MySQL
    cur = mysql.connection.cursor()

    # Consulta SQL para obtener los datos de la tabla de posiciones
    cur.execute(f"""
        SELECT e.Nombre AS Club, e.Imagen AS Imagen, tr.Puntos AS PTS, 
            tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
            tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
            tr.Goles_Favor AS GF, tr.Goles_Contra AS GC,
            (tr.Goles_Favor - tr.Goles_Contra) AS DIF
        FROM {tabla} tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Puntos DESC, (tr.Goles_Favor - tr.Goles_Contra) DESC
    """)

    tabla_posiciones_segunda = cur.fetchall()

    cur.close()

    # Asegurarse de que cada equipo tenga la ruta completa de la imagen
    for equipo in tabla_posiciones_segunda:
        equipo['Siglas'] = equipo['Club'][:3].upper()
        equipo['Imagen'] = f"/static/images/equipos/{equipo['Imagen']}"

    # Renderizar la plantilla HTML con los datos de la tabla de posiciones
    return render_template('tabla_posiciones_segunda.html', tabla_posiciones_segunda=tabla_posiciones_segunda)


####################################################################


# Muestra la tabla de juvenil primera división
@app.route('/tabla-juvenil-p')
def tabla_juvenil_p():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_juvenil_p tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_juvenil_p = cur.fetchall()
    cur.close()

    return render_template('tabla_juvenil_p.html', tabla_juvenil_p=tabla_juvenil_p)


# Muestra la tabla de adulta primera división
@app.route('/tabla-adulta-p')
def tabla_adulta_p():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_adulta_p tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_adulta_p = cur.fetchall()
    cur.close()

    return render_template('tabla_adulta_p.html', tabla_adulta_p=tabla_adulta_p)


# Muestra la tabla de senior primera división
@app.route('/tabla-senior-p')
def tabla_senior_p():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_senior_p tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_senior_p = cur.fetchall()
    cur.close()

    return render_template('tabla_senior_p.html', tabla_senior_p=tabla_senior_p)


# Muestra la tabla de super senior primera división
@app.route('/tabla-supersenior-p')
def tabla_supersenior_p():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_supersenior_p tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_supersenior_p = cur.fetchall()
    cur.close()

    return render_template('tabla_supersenior_p.html', tabla_supersenior_p=tabla_supersenior_p)



# Muestra la tabla de honor primera división
@app.route('/tabla-honor-p')
def tabla_honor_p():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_honor_p tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_honor_p = cur.fetchall()
    cur.close()

    return render_template('tabla_honor_p.html', tabla_honor_p=tabla_honor_p)



# Muestra la tabla de juvenil segunda división
@app.route('/tabla-juvenil-s')
def tabla_juvenil_s():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_juvenil_s tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_juvenil_s = cur.fetchall()
    cur.close()

    return render_template('tabla_juvenil_s.html', tabla_juvenil_s=tabla_juvenil_s)



# Muestra la tabla de adulta segunda división
@app.route('/tabla-adulta-s')
def tabla_adulta_s():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_adulta_s tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_adulta_s = cur.fetchall()
    cur.close()

    return render_template('tabla_adulta_s.html', tabla_adulta_s=tabla_adulta_s)


# Muestra la tabla de senior segunda división
@app.route('/tabla-senior-s')
def tabla_senior_s():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_senior_s tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_senior_s = cur.fetchall()
    cur.close()

    return render_template('tabla_senior_s.html', tabla_senior_s=tabla_senior_s)


# Muestra la tabla de super senior segunda división
@app.route('/tabla-supersenior-s')
def tabla_supersenior_s():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_supersenior_s tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_supersenior_s = cur.fetchall()
    cur.close()

    return render_template('tabla_supersenior_s.html', tabla_supersenior_s=tabla_supersenior_s)


# Muestra la tabla de honor segunda división
@app.route('/tabla-honor-s')
def tabla_honor_s():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM tabla_honor_s tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_honor_s = cur.fetchall()
    cur.close()

    return render_template('tabla_honor_s.html', tabla_honor_s=tabla_honor_s)
########### FIN TABLAS DE POSICIONES ############
#################################################



##########
#@app.route('/static/css/style.css')
#def style():
#    css_content = render_template_string(open('static/css/style.css').read())
#    return css_content

##########

if __name__ == '__main__':
   app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)