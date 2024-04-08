from flask import Flask, render_template, request, redirect, url_for, session, jsonify, render_template_string, send_from_directory
from flask_mysqldb import MySQL
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

@app.route('/')
def home():
    return render_template('index.html')   

@app.route('/admin')
def admin():
    return render_template('admin.html')   

@app.route('/galeria')
def galeria():
    return render_template('galeria.html')   

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

######################################################
#############Descargar formularios####################
UPLOAD_FOLDER = 'archivos'
# Verificar si el directorio de carga existe, si no, crearlo
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'archivo' not in request.files:
        return redirect(request.url)
    archivo = request.files['archivo']
    if archivo.filename == '':
        return redirect(request.url)
    if archivo:
        archivo.save(os.path.join(app.config['UPLOAD_FOLDER'], archivo.filename))
        return render_template('formularios.html')

@app.route('/archivos/<nombre_archivo>')
def descargar_archivo(nombre_archivo):
    return send_from_directory(app.config['UPLOAD_FOLDER'], nombre_archivo)

# Ruta para listar jugadores
@app.route('/listar-jugadores')
def listar_jugadores(): 
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM jugador")
    jugadores = cur.fetchall()

    # Obtener el parámetro de consulta 'categoria'
    categoria = request.args.get('categoria')
    
    # Definir la consulta base para obtener jugadores
    consulta_jugadores = "SELECT * FROM jugador WHERE Equipo_ID = %s"
    
    # Si se proporciona la categoría, ajusta la consulta para filtrar jugadores por esa categoría
    if categoria:
        consulta_jugadores += " AND Categoria_ID = %s"
        cur.execute(consulta_jugadores, (id, categoria))
    else:
        cur.execute(consulta_jugadores, (id,))
    cur.close()
    
    
    return render_template("listar_jugadores.html", jugadores=jugadores)



# Ruta para listar equipos
@app.route('/listar-equipos')
def listar_equipos(): 
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM equipo")
    equipos = cur.fetchall()
    cur.close()
    
    return render_template("listar_equipos.html", equipos=equipos)


@app.route('/equipo/<int:id>')
def obtener_equipo(id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM equipo WHERE id = %s", (id,))
    equipo = cur.fetchone()
    
    # Obtener el parámetro de consulta 'categoria'
    categoria = request.args.get('categoria')
    
    # Definir la consulta base para obtener jugadores
    consulta_jugadores = "SELECT * FROM jugador WHERE Equipo_ID = %s"
    
    # Si se proporciona la categoría, ajusta la consulta para filtrar jugadores por esa categoría
    if categoria:
        consulta_jugadores += " AND Categoria_ID = %s"
        cur.execute(consulta_jugadores, (id, categoria))
    else:
        cur.execute(consulta_jugadores, (id,))
    
    jugadores = cur.fetchall()
    
    cur.close()

    if equipo:
        # Definir equipo_id aquí para pasarlo a la plantilla
        equipo_id = id

        # Renderiza la plantilla HTML correspondiente al equipo y pasa la información del equipo, jugadores y equipo_id
        return render_template(f"equipos/equipo{id}.html", equipo=equipo, jugadores=jugadores, equipo_id=equipo_id)
    else:
        # Si no se encuentra el equipo, devuelve un mensaje de error y un código de estado 404
        return jsonify({"error": "equipo no encontrado"}), 404




@app.route('/jugador/<int:id>')
def obtener_jugador(id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM jugador WHERE id = %s", (id,))
    jugador = cur.fetchone()
    cur.close()

    if jugador:
        # Devuelve los detalles del jugador como una respuesta JSON
        return render_template("detallesjugadores.html", jugador=jugador)
    else:
        # Si no se encuentra el jugador, devuelve un mensaje de error y un código de estado 404
        return jsonify({"error": "Jugador no encontrado"}), 404


# estadisticas jugadores
    
@app.route('/estadisticas-jugadores')
def estadisticas_jugadores():
    cur = mysql.connection.cursor()
    cur.execute("SELECT j.Nombre, j.Apellido_Paterno, j.Apellido_Materno, e.Goles_Anotados, e.Asistencias, e.Tarjetas_Amarillas, e.Tarjetas_Rojas FROM jugador j JOIN est_jugador_c e ON j.ID = e.Jugador_ID")
    jugadores = cur.fetchall()
    cur.close()

    if jugadores:
        return render_template("estadisticas_jugadores.html", jugadores=jugadores)
    else:
        return jsonify({"error": "No se encontraron jugadores"}), 404


from flask import request

# Resultados de partidos por jornada
@app.route('/partidos', methods=['GET', 'POST'])
def resultados_partidos():
    if request.method == 'POST':
        ID_jornada = request.form['ID_jornada']  # Obtén el valor de la jornada seleccionada del formulario
    else:
        ID_jornada = 1  # Valor por defecto si no se ha enviado el formulario

    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT p.Resultado, p.Ubicacion, p.Fecha, e1.Nombre AS Equipo_Local, e2.Nombre AS Equipo_Visitante, c.Nombre AS Nombre_Categoria
        FROM partido p
        JOIN equipo e1 ON p.Equipo_Local_ID = e1.ID
        JOIN equipo e2 ON p.Equipo_Visitante_ID = e2.ID
        JOIN categoria c ON p.ID_categoria = c.ID
        WHERE p.ID_jornada = %s
    """, (ID_jornada,))
    partidos = cur.fetchall()
    cur.close()

    # Inicializar el diccionario de categorías
    categorias = {}

    # Iterar sobre los partidos y agregarlos a las categorías correspondientes
    for partido in partidos:
        # Verificar si la categoría ya existe en el diccionario
        if partido['Nombre_Categoria'] not in categorias:
            # Si no existe, inicializar una lista vacía para esa categoría
            categorias[partido['Nombre_Categoria']] = []
        # Agregar el partido a la lista de la categoría correspondiente
        categorias[partido['Nombre_Categoria']].append(partido)

    # Renderizar el template con las categorías
    return render_template("resultados_partidos.html", categorias=categorias)



#############################################
###########Asistencia a partridos############
@app.route('/asistencia-jugadores')
def mostrar_jugadores():
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, nombre FROM jugador")
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

        # Calcular el total de asistencias para el jugador
        total_asistencias = sum(asistencia['total'] for asistencia in asistencia_result)
        asistencia_total[jugador['id']] = total_asistencias

        # Actualizar el total de asistencias por jornada para todos los jugadores
        for jornada in jornadas:
            total_asistencias_por_jornada[f'J{jornada}'] += jugador_asistencia.get(jornada, 0)

        # Actualizar la asistencia del jugador para todas las jornadas
        asistencia_jornadas[jugador['id']] = jugador_asistencia
        total_jornadas_asistidas[jugador['id']] = total_asistencias

    cur.close()

    return render_template('asistencia.html', jugadores=jugadores, asistencia_jornadas=asistencia_jornadas, total_jornadas_asistidas=total_jornadas_asistidas, total_asistencias_por_jornada=total_asistencias_por_jornada, asistencia_total=asistencia_total, jornadas=jornadas)

############################################
############################################


########### TABLAS DE POSICIONES ############
#############################################
#############################################
#############################################


# Muestra la tabla general de primera división
@app.route('/tabla-posiciones')
def tabla_posiciones():
    # Obtener la categoría seleccionada
    categoria_seleccionada = request.args.get('categoria', 'all')

    # Determinar la tabla a consultar según la categoría seleccionada
    if categoria_seleccionada == 'all':
        tabla = 'torneo_regular'
    elif categoria_seleccionada == '1':
        tabla = 'tabla_juvenil_p'
    elif categoria_seleccionada == '2':
        tabla = 'tabla_adulta_p'
    elif categoria_seleccionada == '3':
        tabla = 'tabla_senior_p'
    elif categoria_seleccionada == '4':
        tabla = 'tabla_supersenior_p'
    elif categoria_seleccionada == '5':
        tabla = 'tabla_honor_p'

    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla correspondiente a la categoría seleccionada
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM {} tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """.format(tabla))

    tabla_posiciones = cur.fetchall()
    cur.close()

    return render_template('tabla_posiciones.html', tabla_posiciones=tabla_posiciones)




# Muestra la tabla general de segunda división
@app.route('/tabla-posiciones-segunda')
def tabla_posiciones_segunda():
    cur = mysql.connection.cursor()

    # Consulta para obtener los datos de la tabla torneo_regular_segunda
    cur.execute("""
        SELECT Posicion AS Pos, e.Nombre AS Club, tr.Puntos AS PTS, 
               tr.P_Jugados AS PJ, tr.P_Ganados AS PG, 
               tr.P_Empatados AS PE, tr.P_Perdidos AS PP, 
               tr.Goles_Favor AS GF, tr.Goles_Contra AS GC
        FROM torneo_regular_segunda tr
        JOIN equipo e ON tr.Equipo_ID = e.ID
        ORDER BY tr.Posicion
    """)

    tabla_posiciones_segunda = cur.fetchall()
    cur.close()

    return render_template('tabla_posiciones_segunda.html', tabla_posiciones_segunda=tabla_posiciones_segunda)

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
