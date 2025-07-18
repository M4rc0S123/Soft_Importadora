/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class SeguimientoPlazo {
     private int idSeguimiento;
    private int idImportacion;
    private int idTipoSeguimiento;
    private String tipoNombre; // nombre del tipo seguimiento
    private String fechaProgramada;
    private String fechaReal;
    
    public int getIdSeguimiento() {
        return idSeguimiento;
    }

    public void setIdSeguimiento(int idSeguimiento) {
        this.idSeguimiento = idSeguimiento;
    }

    public int getIdImportacion() {
        return idImportacion;
    }

    public void setIdImportacion(int idImportacion) {
        this.idImportacion = idImportacion;
    }

    public int getIdTipoSeguimiento() {
        return idTipoSeguimiento;
    }

    public void setIdTipoSeguimiento(int idTipoSeguimiento) {
        this.idTipoSeguimiento = idTipoSeguimiento;
    }

    public String getTipoNombre() {
        return tipoNombre;
    }

    public void setTipoNombre(String tipoNombre) {
        this.tipoNombre = tipoNombre;
    }

    public String getFechaProgramada() {
        return fechaProgramada;
    }

    public void setFechaProgramada(String fechaProgramada) {
        this.fechaProgramada = fechaProgramada;
    }

    public String getFechaReal() {
        return fechaReal;
    }

    public void setFechaReal(String fechaReal) {
        this.fechaReal = fechaReal;
    }

    public int getResponsable() {
        return responsable;
    }

    public void setResponsable(int responsable) {
        this.responsable = responsable;
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
    private int responsable;
    private String observaciones;
    private String estado;
    
}
