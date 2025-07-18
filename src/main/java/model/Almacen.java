
package model;

import java.util.Date;

public class Almacen {
    private int idAlmacen;
    private int idImportacion;
    private Date fechaRecepcion;
    private int recibidoPor;
    private String observaciones;
    private String estado; // completo, parcial, faltantes

    // Constructor vacío
    public Almacen() {
    }

    // Constructor con parámetros
    public Almacen(int idImportacion, Date fechaRecepcion, int recibidoPor, 
                  String observaciones, String estado) {
        this.idImportacion = idImportacion;
        this.fechaRecepcion = fechaRecepcion;
        this.recibidoPor = recibidoPor;
        this.observaciones = observaciones;
        this.estado = estado;
    }

    // Getters y Setters
    public int getIdAlmacen() {
        return idAlmacen;
    }

    public void setIdAlmacen(int idAlmacen) {
        this.idAlmacen = idAlmacen;
    }

    public int getIdImportacion() {
        return idImportacion;
    }

    public void setIdImportacion(int idImportacion) {
        this.idImportacion = idImportacion;
    }

    public Date getFechaRecepcion() {
        return fechaRecepcion;
    }

    public void setFechaRecepcion(Date fechaRecepcion) {
        this.fechaRecepcion = fechaRecepcion;
    }

    public int getRecibidoPor() {
        return recibidoPor;
    }

    public void setRecibidoPor(int recibidoPor) {
        this.recibidoPor = recibidoPor;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}