package mx.gox.infonavit.sicj.catalogos

class TipoDeReproceso implements Serializable {

    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_reproceso', params:[sequence:'tipo_de_reproceso_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
