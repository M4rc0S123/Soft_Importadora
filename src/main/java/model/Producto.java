package model;

public class Producto {

    int id_producto;
    String nombre_producto;
    String descripcion;
    String unidad_medida;
    String categoria;
    String ruta_imagen;

    public Producto() {

    }

    public Producto(String nombre_producto, String descripcion, String unidad_medida,
            String categoria, String ruta_imagen) {
        this.nombre_producto = nombre_producto;
        this.descripcion = descripcion;
        this.unidad_medida = unidad_medida;
        this.categoria = categoria;
        this.ruta_imagen = ruta_imagen;
    }

    public int getId_producto() {
        return id_producto;
    }

    public void setId_producto(int id_producto) {
        this.id_producto = id_producto;
    }

    public String getNombre_producto() {
        return nombre_producto;
    }

    public void setNombre_producto(String nombre_producto) {
        this.nombre_producto = nombre_producto;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getUnidad_medida() {
        return unidad_medida;
    }

    public void setUnidad_medida(String unidad_medida) {
        this.unidad_medida = unidad_medida;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getRuta_imagen() {
        return ruta_imagen;
    }

    public void setRuta_imagen(String ruta_imagen) {
        this.ruta_imagen = ruta_imagen;
    }
}
