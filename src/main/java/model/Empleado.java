package model;
import java.io.Serializable;
public class Empleado implements Serializable{
    private int id_empleado;
    private String nombre;
    private String apellido;
    private String correo;
    private String contrasena;
    private boolean estado;
    private Rol rol;
    
    public Empleado() {}
    
    public Empleado(int id_empleado, String nombre, String apellido, String correo, boolean estado, Rol rol) {
        this.id_empleado = id_empleado;
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.estado = estado;
        this.rol = rol;
    }
    
    public Empleado(int id_empleado, String nombre, String apellido, String correo, String contrasena, boolean estado, Rol rol) {
        this.id_empleado = id_empleado;
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.contrasena = contrasena;
        this.estado = estado;
        this.rol = rol;
    }

    public int getId_empleado() {
        return id_empleado;
    }

    public void setId_empleado(int id_empleado) {
        this.id_empleado = id_empleado;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public Rol getRol() {
        return rol;
    }

    public void setRol(Rol rol) {
        this.rol = rol;
    }

    @Override
    public String toString() {
        return nombre + " " + apellido;
    }
}
