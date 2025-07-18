/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// model/Devolucion.java
package model;

import java.sql.Date;

public class Devolucion {
    private int id_devolucion;
    private int id_importacion;
    private Date fecha_devolucion;
    private String motivo;
    private String responsable;
    private String estado;
    
    // Getters y setters
    public int getId_devolucion() {
        return id_devolucion;
    }
    public void setId_devolucion(int id_devolucion) {
        this.id_devolucion = id_devolucion;
    }
    public int getId_importacion() {
        return id_importacion;
    }
    public void setId_importacion(int id_importacion) {
        this.id_importacion = id_importacion;
    }
    public Date getFecha_devolucion() {
        return fecha_devolucion;
    }
    public void setFecha_devolucion(Date fecha_devolucion) {
        this.fecha_devolucion = fecha_devolucion;
    }
    public String getMotivo() {
        return motivo;
    }
    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }
    public String getResponsable() {
        return responsable;
    }
    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }
    public String getEstado() {
        return estado;
    }
    public void setEstado(String estado) {
        this.estado = estado;
    }
}