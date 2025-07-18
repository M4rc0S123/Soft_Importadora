package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Proveedor;
import util.MySQLConexion;

public class ProveeControl {
    public List<Proveedor> LisProvee(){
    List<Proveedor> lis=new ArrayList();
    Connection cn=MySQLConexion.getConexion();
    try{
     String sql="select id_proveedor,nombre_empresa,contacto, correo, telefono, direccion, pais_origen from proveedores";   
     PreparedStatement st=cn.prepareStatement(sql);
     ResultSet rs=st.executeQuery();
     while(rs.next()){
       Proveedor p=new Proveedor();
       p.setId_proveedor(rs.getInt(1));
       p.setNombre_empresa(rs.getString(2));
       p.setContacto(rs.getString(3));
       p.setCorreo(rs.getString(4));
       p.setTelefono(rs.getString(5));
       p.setDireccion(rs.getString(6));
       p.setPais_origen(rs.getString(7));
       lis.add(p);
     }
    }catch(Exception ex){
      ex.printStackTrace();
    }
    return lis;   
   }
    
    public void AddProvee(String nom_empresa, String contacto, String correo, String telefono, String direccion, String pais_origen){
    Connection cn=MySQLConexion.getConexion();
    try{
     String sql="insert into proveedores (nombre_empresa,contacto, correo, telefono, direccion, pais_origen) values (?,?,?,?,?,?)";   
     PreparedStatement st=cn.prepareStatement(sql);
     st.setString(1, nom_empresa);
     st.setString(2, contacto);
     st.setString(3, correo);
     st.setString(4, telefono);
     st.setString(5, direccion);
     st.setString(6, pais_origen);
     st.executeUpdate();
    }catch(Exception ex){
      ex.printStackTrace();
    }  
   }
}
