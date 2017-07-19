package mx.gox.infonavit.sicj.catalogos

class TipoDeParteMateria implements Serializable {

    TipoDeParte tipoDeParte
    Materia materia
    
    static constraints = {
        tipoDeParte (nullable:false)
        materia (nullable:false)
    }
    
    static mapping = {
        id composite : ['tipoDeParte', 'materia']
    }
}
