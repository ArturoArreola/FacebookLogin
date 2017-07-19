package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario

class ControlJuicio implements Serializable{

    Juicio juicio
    Date fechaDeReactivacion
    Usuario reactivadoPor
    Date fechaDeCancelacion
    Usuario canceladoPor
    Date fechaDeWfTerminado
    Usuario wfTerminadoPor
    Date fechaDeArchivoDefinitivo
    Usuario archivadoPor
    Date fechaDeArchivoHistorico
    Usuario enviadoHistoricoPor
    
    static constraints = {
    juicio (nullable: false)
    fechaDeReactivacion (nullable: true)
    reactivadoPor (nullable: true)
    fechaDeCancelacion (nullable: true)
    canceladoPor (nullable: true)
    fechaDeWfTerminado (nullable: true)
    wfTerminadoPor (nullable: true)
    fechaDeArchivoDefinitivo (nullable: true)
    archivadoPor (nullable: true)
    fechaDeArchivoHistorico (nullable: true)
    enviadoHistoricoPor (nullable: true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_control_juicio', params:[sequence:'control_juicio_id_seq']
    }
}
