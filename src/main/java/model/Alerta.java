/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

public class Alerta {
    private int idAlerta;
    private int idImportacion;
    private String tipoAlerta;  // Usamos String para mapear directamente con el ENUM de la BD
    private String mensaje;
    private LocalDateTime fechaGenerada;
    private int empleadoDestinatario;

    // Constantes para los tipos de alerta (coinciden con el ENUM de la BD)
    public static final String TIPO_RETRASO = "retraso";
    public static final String TIPO_VENCIMIENTO_PROXIMO = "vencimiento_proximo";
    public static final String TIPO_CONFIRMACION = "confirmacion";

    // Constructor vacío
    public Alerta() {
    }

    // Constructor con parámetros
    public Alerta(int idImportacion, String tipoAlerta, String mensaje, int empleadoDestinatario) {
        this.idImportacion = idImportacion;
        setTipoAlerta(tipoAlerta);  // Usamos el setter para validación
        this.mensaje = mensaje;
        this.empleadoDestinatario = empleadoDestinatario;
        this.fechaGenerada = LocalDateTime.now();
    }

    // Getters y Setters
    public int getIdAlerta() {
        return idAlerta;
    }

    public void setIdAlerta(int idAlerta) {
        this.idAlerta = idAlerta;
    }

    public int getIdImportacion() {
        return idImportacion;
    }

    public void setIdImportacion(int idImportacion) {
        this.idImportacion = idImportacion;
    }

    public String getTipoAlerta() {
        return tipoAlerta;
    }

    public void setTipoAlerta(String tipoAlerta) {
        // Validamos que el tipo de alerta sea uno de los permitidos
        if (tipoAlerta != null && 
            (tipoAlerta.equals(TIPO_RETRASO) || 
             tipoAlerta.equals(TIPO_VENCIMIENTO_PROXIMO) || 
             tipoAlerta.equals(TIPO_CONFIRMACION))) {
            this.tipoAlerta = tipoAlerta;
        } else {
            throw new IllegalArgumentException("Tipo de alerta no válido: " + tipoAlerta);
        }
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public LocalDateTime getFechaGenerada() {
        return fechaGenerada;
    }

    public void setFechaGenerada(LocalDateTime fechaGenerada) {
        this.fechaGenerada = fechaGenerada;
    }

    public int getEmpleadoDestinatario() {
        return empleadoDestinatario;
    }

    public void setEmpleadoDestinatario(int empleadoDestinatario) {
        this.empleadoDestinatario = empleadoDestinatario;
    }

    // Método para verificar el tipo de alerta
    public boolean esTipoRetraso() {
        return TIPO_RETRASO.equals(this.tipoAlerta);
    }

    public boolean esTipoVencimientoProximo() {
        return TIPO_VENCIMIENTO_PROXIMO.equals(this.tipoAlerta);
    }

    public boolean esTipoConfirmacion() {
        return TIPO_CONFIRMACION.equals(this.tipoAlerta);
    }

    @Override
    public String toString() {
        return "Alerta{" +
                "idAlerta=" + idAlerta +
                ", idImportacion=" + idImportacion +
                ", tipoAlerta='" + tipoAlerta + '\'' +
                ", mensaje='" + mensaje + '\'' +
                ", fechaGenerada=" + fechaGenerada +
                ", empleadoDestinatario=" + empleadoDestinatario +
                '}';
    }
}