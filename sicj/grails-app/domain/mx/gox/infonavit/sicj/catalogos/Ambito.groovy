package mx.gox.infonavit.sicj.catalogos

class Ambito implements Serializable{

    String nombre
    String descripcion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_ambito', params:[sequence:'ambito_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
