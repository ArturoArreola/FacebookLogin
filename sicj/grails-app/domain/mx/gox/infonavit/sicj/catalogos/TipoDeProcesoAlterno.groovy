package mx.gox.infonavit.sicj.catalogos

class TipoDeProcesoAlterno implements Serializable {

    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_proceso_alterno', params:[sequence:'tipo_de_proceso_alterno_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
