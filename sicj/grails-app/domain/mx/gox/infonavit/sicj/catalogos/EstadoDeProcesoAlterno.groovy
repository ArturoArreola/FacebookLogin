package mx.gox.infonavit.sicj.catalogos

class EstadoDeProcesoAlterno implements Serializable{

    String nombre
    String descripcion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_estado_de_proceso_alterno', params:[sequence:'estado_de_proceso_alterno_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
