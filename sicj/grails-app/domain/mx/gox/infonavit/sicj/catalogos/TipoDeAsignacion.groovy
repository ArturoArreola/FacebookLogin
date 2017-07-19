package mx.gox.infonavit.sicj.catalogos

class TipoDeAsignacion implements Serializable{

    String nombre
    String descripcion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_asignacion', params:[sequence:'tipo_de_asignacion_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
