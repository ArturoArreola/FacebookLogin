package mx.gox.infonavit.sicj.admin

import mx.gox.infonavit.sicj.catalogos.Estado

class Delegacion implements Serializable{

    String nombre
    Estado estado
    Division division
    String nombreCarpeta
    String nombreCorto
    
    static belongsTo = [Estado,Division]
    
    static Usuario getGerenteJuridico(long delegacionId) {
        return Usuario.find("from Usuario u where u.gerenteJuridico =true and u.enabled = true and u.delegacion.id = :delegacionId", [delegacionId: delegacionId])
    }
    
    static constraints = {
        nombre(blank:false)
        estado(nullable:false)
        division(nullable:false)
        nombreCarpeta(nullable:false)
        nombreCorto(nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_delegacion', params:[sequence:'delegacion_id_seq']
    }
    
    String toString () {
        "${id} - ${nombre}"
    }
}
