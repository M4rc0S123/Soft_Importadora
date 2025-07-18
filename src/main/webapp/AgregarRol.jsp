<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Adicionar Rol</title>
       
        <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            background-color: #f4f4f4;
        }
        .sidebar {
            width: 220px;
            background-color: #003366;
            color: white;
            height: 100vh;
            position: fixed;
            display: flex;
            flex-direction: column;
            padding-top: 20px;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .sidebar a {
            padding: 12px 20px;
            text-decoration: none;
            color: white;
            display: block;
            transition: background 0.3s;
        }
        .sidebar a:hover {
            background-color: #0059b3;
        }
        .main-content {
            margin-left: 220px;
            padding: 20px;
            flex-grow: 1;
        }
         .form-container {
                background-color: #ffffff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 500px; /* Ancho máximo para el formulario */
            }
            
            .form-group {
                margin-bottom: 20px; /* Espacio entre grupos de formulario */
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #333;
            }
            .form-control {
                width: 100%;
                padding: 12px;
                border: 1px solid #ced4da;
                border-radius: 5px;
                font-size: 1rem;
                box-shadow: inset 0 1px 2px rgba(0,0,0,0.075);
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }
            .form-control:focus {
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1rem;
                transition: background-color 0.2s ease-in-out, transform 0.1s ease-in-out;
                margin-right: 10px; /* Espacio entre botones */
            }
            .btn-primary {
                background-color: #007bff;
                color: white;
            }
            .btn-primary:hover {
                background-color: #0056b3;
                transform: translateY(-1px);
            }
            .btn-danger {
                background-color: #dc3545;
                color: white;
            }
            .btn-danger:hover {
                background-color: #c82333;
                transform: translateY(-1px);
            }
            h2.text-cyan {
                color: #008cba; /* Un tono de cian */
                margin-bottom: 30px;
                font-size: 2rem;
                text-align: center;
                width: 100%;
            }
            
        .header-importacion {
            margin-bottom: 20px;
        }
        .controls {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-top: 10px;
        }
        .search-container {
            display: flex;
            align-items: center;
        }
        .search-input {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
        }
        .search-button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 0 5px 5px 0;
            cursor: pointer;
            margin-left: -5px;
        }
        .new-importacion-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        .importacion-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 5px;
            overflow: hidden;
        }
        .importacion-table th, .importacion-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .importacion-table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        .importacion-table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .importacion-table .actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            align-items: center;
        }
        .importacion-table .action-icon {
            cursor: pointer;
            font-size: 16px;
        }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2>Menú</h2>
            <a href="DashboardServlet">Principal</a>
            <a href="rol">Roles</a>
            <a href="empleado">Empleados</a>
            <a href="LisProvee.jsp">Proveedores</a>
            <a href="producto">Productos</a>
            <a href="buscarImportacion.jsp">Importaciones</a>
            <a href="AlmacenServlet">Almacenes</a>
            <a href="ListarDevolucionesServlet">Devoluciones</a>
        </div>
        <div class="main-content">
        <h2 class="text-cyan">Registro De Roles</h2>
        <form action="rol?action=add" method="post" id="id_form">
                <div class="form-group">
                    <label for="nombre">Nombre</label>
                    <input class="form-control" type="text" id="nombre" name="nombre" 
                           placeholder="Ingrese nombre del Rol" required>
                </div>
               
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Agregar Rol</button>
                    <button type="button" class="btn btn-danger" 
                            onclick="window.location.href='rol'">Cancelar</button>
                </div>
            </form>
        </div>
        
        <script>
            // Validación adicional del lado del cliente
            document.getElementById('id_form').addEventListener('submit', function(e) {
                const correo = document.getElementById('correo').value;
                if (!correo.includes('@')) {
                    alert('Por favor ingrese un correo electrónico válido');
                    e.preventDefault();
                }
                
                const contrasena = document.getElementById('contrasena').value;
                if (contrasena.length < 6) {
                    alert('La contraseña debe tener al menos 6 caracteres');
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>
