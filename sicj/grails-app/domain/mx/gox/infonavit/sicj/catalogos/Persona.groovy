package mx.gox.infonavit.sicj.catalogos

class Persona implements Serializable{

    String nombre
    String apellidoPaterno
    String apellidoMaterno
    String rfc
    String numeroSeguroSocial
    TipoDePersona tipoDePersona
    
    static constraints = {
        nombre (blank:false)
        apellidoPaterno (nullable:true)
        apellidoMaterno (nullable:true)
        rfc (nullable:true)
        numeroSeguroSocial (nullable:true)
        tipoDePersona (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_persona', params:[sequence:'persona_id_seq']
    }
    
    String toString () {
        "${nombre} ${(apellidoPaterno)?:""} ${(apellidoMaterno)?:""}"
    }
}
