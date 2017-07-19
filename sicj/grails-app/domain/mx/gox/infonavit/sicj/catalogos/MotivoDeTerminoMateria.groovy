package mx.gox.infonavit.sicj.catalogos

class MotivoDeTerminoMateria implements Serializable{

    MotivoDeTermino motivo
    Materia materia
    
    static constraints = {
        motivo (nullable:false)
        materia (nullable:false)
    }
    
    static mapping = {
        id composite : ['motivo', 'materia']
    }
}
