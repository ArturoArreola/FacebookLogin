package mx.gox.infonavit.sicj.admin

class Region implements Serializable{

    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_region', params:[sequence:'region_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
