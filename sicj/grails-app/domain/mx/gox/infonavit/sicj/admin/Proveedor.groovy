package mx.gox.infonavit.sicj.admin

class Proveedor implements Serializable{

    String nombre
    Delegacion delegacion
    boolean activo = true
    
    static belongsTo = [Delegacion]
    
    static Usuario getResponsable(long proveedorId) {
        return Usuario.find("from Usuario u where u.proveedorResponsable = true and u.enabled = true and u.proveedor.id = :proveedorId", [proveedorId: proveedorId])
    }
    
    static constraints = {
        nombre(blank:false)
        delegacion(nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_proveedor', params:[sequence:'proveedor_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
