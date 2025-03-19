document.addEventListener("DOMContentLoaded", function () {
    actualizarCarrito();

    // Menú desplegable de categorías
    const btnMenu = document.getElementById("btn-menu");
    const categorias = document.querySelector(".categorias");

    btnMenu.addEventListener("click", function () {
        categorias.classList.toggle("mostrar");
    });

    // Cierra el menú si se hace clic fuera de él
    document.addEventListener("click", function (event) {
        if (!btnMenu.contains(event.target) && !categorias.contains(event.target)) {
            categorias.classList.remove("mostrar");
        }
    });
});

// Obtener o inicializar el carrito en localStorage
let carrito = JSON.parse(localStorage.getItem("carrito")) || [];

// Función para agregar productos al carrito
function agregarAlCarrito(nombre, precio) {
    precio = parseFloat(precio); 

    if (isNaN(precio)) {
        console.error("Error: Precio no es un número válido para", nombre);
        return;
    }

    carrito.push({ nombre, precio });
    localStorage.setItem("carrito", JSON.stringify(carrito));

    console.log("Producto agregado:", { nombre, precio });
    console.log("Carrito actualizado:", carrito);

    alert(`${nombre} agregado al carrito.`);
    actualizarCarrito();
}

// Función para actualizar la vista del carrito
function actualizarCarrito() {
    const carritoContainer = document.getElementById("carrito-contenido");
    const totalSpan = document.getElementById("total-carrito");

    if (!carritoContainer || !totalSpan) return;

    carritoContainer.innerHTML = "";
    let total = 0;

    carrito.forEach((producto, index) => {
        let precioNumerico = parseFloat(producto.precio);
        total += precioNumerico;

        let item = document.createElement("li");
        item.textContent = `${producto.nombre} - S/ ${precioNumerico.toFixed(2)}`;

        let btnEliminar = document.createElement("button");
        btnEliminar.textContent = "❌";
        btnEliminar.onclick = function () {
            eliminarDelCarrito(index);
        };

        item.appendChild(btnEliminar);
        carritoContainer.appendChild(item);
    });

    totalSpan.textContent = `S/ ${total.toFixed(2)}`;
    console.log("Total actualizado:", total);
}

// Función para eliminar un producto del carrito
function eliminarDelCarrito(index) {
    carrito.splice(index, 1);
    localStorage.setItem("carrito", JSON.stringify(carrito));
    actualizarCarrito();
}