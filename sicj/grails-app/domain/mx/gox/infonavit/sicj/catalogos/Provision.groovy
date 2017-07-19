package mx.gox.infonavit.sicj.catalogos

class Provision implements Serializable{

    String nombre
    String descripcion
    String abreviacion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
        abreviacion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_provision', params:[sequence:'provision_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
