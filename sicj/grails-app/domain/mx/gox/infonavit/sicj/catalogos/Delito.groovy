package mx.gox.infonavit.sicj.catalogos

class Delito implements Serializable{

    String nombre
    TipoDeAsignacion tipoDeAsignacion
    
    static constraints = {
        nombre (nullable:false)
        tipoDeAsignacion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_delito', params:[sequence:'delito_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
