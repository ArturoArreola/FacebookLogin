package mx.gox.infonavit.sicj.auditoria

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.PreguntaEtapaProcesal
import mx.gox.infonavit.sicj.catalogos.RespuestaPregunta
import mx.gox.infonavit.sicj.juicios.Juicio

class BitacoraDeWorkFlow implements Serializable{
    
    Juicio juicio
    PreguntaEtapaProcesal preguntaAtendida
    Usuario usuario
    Date fechaDeMovimiento
    RespuestaPregunta respuestaAnterior
    String valorRespuestaAnterior
    String datosAuxiliaresAnteriores
    String observaciones
    
    static constraints = {
        juicio (nullable:false)
        preguntaAtendida (nullable:false)
        respuestaAnterior (nullable:false)
        usuario (nullable:false)
        fechaDeMovimiento (nullable:false)
        valorRespuestaAnterior (nullable:true)
        datosAuxiliaresAnteriores (nullable:true)
        observaciones (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_bitacora_de_workflow', params:[sequence:'bitacora_de_workflow_id_seq']
    }
}
