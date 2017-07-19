package mx.gox.infonavit.sicj.catalogos

class TipoAsociado {

    String nombre
    PrestacionReclamada prestacionReclamada
    
    static constraints = {
        nombre (nullable:false)
        prestacionReclamada (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_asociado', params:[sequence:'tipo_asociado_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
