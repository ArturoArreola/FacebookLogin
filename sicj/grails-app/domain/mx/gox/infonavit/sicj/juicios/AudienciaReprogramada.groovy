package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario

class AudienciaReprogramada {
    
    AudienciaJuicio audienciaOriginal
    AudienciaJuicio nuevaAudiencia
    Date fechaDelCambio
    Usuario usuariosQueCambio

    static constraints = {
        audienciaOriginal(nullable:false)
        nuevaAudiencia(nullable:false)
        fechaDelCambio(nullable:false)
        usuariosQueCambio(nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_audiencia_reprogramada', params:[sequence:'audiencia_reprogramada_id_seq']
    }
}
