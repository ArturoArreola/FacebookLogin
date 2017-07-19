package mx.gox.infonavit.sicj.admin

class Despacho implements Serializable{

    String nombre
    Delegacion delegacion
    boolean activo = true
    
    static belongsTo = [Delegacion]
    
    static Usuario getResponsable(long despachoId) {
        return Usuario.find("from Usuario u where u.responsableDelDespacho = true and u.enabled = true and u.despacho.id = :despachoId", [despachoId: despachoId])
    }
    
    static constraints = {
        nombre(blank:false)
        delegacion(nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_despacho', params:[sequence:'despacho_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
