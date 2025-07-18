<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Adicionar Proveedor</title>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <link rel="stylesheet" href="css/bootstrapValidator.css">

        <script src="js/bootstrap.min.js"></script>
        <script src="js/bootstrapValidator.js"></script>
    </head>
    <body>
        <h2 class="text-cyan">Adicionar Proveedor</h2>
        <form action="ProveeServlet" id="id_form">
            <input type="hidden" name="opc" value="1">
            <div class="form-group">
                    <label class="control-label" for="id_nom_empresa">Nombre Empresa</label>
                    <input class="form-control" type="text" id="id_nom_empresa" name="nom_empresa" placeholder="Ingrese el nombre de la empresa">
            </div>
            <div class="form-group">
                    <label class="control-label" for="id_contacto">Contacto</label>
                    <input class="form-control" type="text" id="id_contacto" name="contacto" placeholder="Ingrese contacto">
            </div>
            <div class="form-group">
                    <label class="control-label" for="id_correo">Correo</label>
                    <input class="form-control" type="text" id="id_correo" name="correo" placeholder="Ingrese el correo">
            </div>
            <div class="form-group">
                    <label class="control-label" for="id_telefono">Telefono</label>
                    <input class="form-control" type="text" id="id_telefono" name="telefono" placeholder="Ingrese el telefono">
            </div>
            <div class="form-group">
                    <label class="control-label" for="id_direccion">Direccion</label>
                    <input class="form-control" type="text" id="id_direccion" name="direccion" placeholder="Ingrese la direccion">
            </div>
            <div class="form-group">
                    <label class="control-label" for="id_pais_origen">Pais Origen</label>
                    <input class="form-control" type="text" id="id_pais_origen" name="pais_origen" placeholder="Ingrese el pais origen">
            </div>
            <div class="form-group">
                    <button type="submit" class="btn btn-primary" >Adiciona Proveedor</button>
            </div>
        </form>
    </body>
</html>
