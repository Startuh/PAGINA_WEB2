from flask import Flask, render_template, request, jsonify, session

app = Flask(__name__)
app.secret_key = 'clave_secreta'  # Necesario para manejar sesiones

# Diccionario con productos organizados por categoría
productos = {
    "laboratorio": [
        {"nombre": "Microscopio", "descripcion": "Microscopio de alta resolución.", "precio": 1200},
        {"nombre": "Tubo de ensayo", "descripcion": "Tubo de ensayo de vidrio.", "precio": 5}
    ],
    "medico": [
        {"nombre": "Jeringas", "descripcion": "Jeringas de 5ml.", "precio": 2},
        {"nombre": "Algodón", "descripcion": "Algodón estéril.", "precio": 10}
    ],
    "diabetico": [
        {"nombre": "Glucometro", "descripcion": "Dispositivo para medir la glucosa.", "precio": 150},
        {"nombre": "Tiras para glucosa", "descripcion": "Paquete de 50 tiras.", "precio": 80}
    ]
}

# Página principal
@app.route('/')
def home():
    return render_template('index.html')

# Página de productos según categoría
@app.route('/productos')
def productos_page():
    categoria = request.args.get("categoria", "laboratorio")  # Si no hay categoría, por defecto "laboratorio"
    return render_template('productos.html', categoria=categoria.capitalize(), productos=productos.get(categoria, []))

# Ruta para ver el carrito de compras
@app.route('/carrito')
def ver_carrito():
    carrito = session.get('carrito', [])  # Obtener carrito de la sesión
    total = sum(item['precio'] for item in carrito)  # Calcular el total
    return render_template('carrito.html', carrito=carrito, total=total)

# Ruta para agregar productos al carrito (AJAX)
@app.route('/agregar_al_carrito', methods=['POST'])
def agregar_al_carrito():
    data = request.json
    nombre = data.get('nombre')
    precio = data.get('precio')

    if not nombre or not precio:
        return jsonify({"error": "Faltan datos"}), 400

    # Obtener el carrito de la sesión o crear uno nuevo
    if 'carrito' not in session:
        session['carrito'] = []

    session['carrito'].append({"nombre": nombre, "precio": precio})
    session.modified = True  # Indicar que la sesión ha cambiado

    return jsonify({"mensaje": "Producto agregado al carrito", "carrito": session['carrito']}), 200

# -----------------------
# CONFIGURACIÓN PARA RENDER
# -----------------------
import os

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))  # Render asigna un puerto dinámico
    app.run(host="0.0.0.0", port=port, debug=False)  # Debug False para producción