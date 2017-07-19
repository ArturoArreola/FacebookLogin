package mx.gox.infonavit.sicj.catalogos

class AutoridadMunicipio implements Serializable {

    Autoridad autoridad
    Municipio municipio
    
    static constraints = {
        autoridad (nullable:false)
        municipio (nullable:false)
    }
    
    static mapping = {
        id composite : ['autoridad', 'municipio']
    }
}
