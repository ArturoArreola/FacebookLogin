package mx.gox.infonavit.sicj.catalogos

class MotivoDeTermino implements Serializable {

    String nombre
    boolean activo
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_motivo_de_termino', params:[sequence:'motivo_de_termino_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
