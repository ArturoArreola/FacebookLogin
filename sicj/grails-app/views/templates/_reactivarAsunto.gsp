<center>
    <div class="alert alert-warning text-justify">
        <strong>Importante: (Aplica sólo para error de captura)</strong> El juicio será regresado a la etapa y pregunta que ústed desee, sin embargo, todas las respuestas y archivos cargados en el workflow a partir de ese punto serán eliminados y no podrán recuperarse. Los archivos subidos directamente y en los apartados de acuerdos y promociones no se verán afectados.
    </div>
</center>
<g:form action="reactivarJuicio" method="POST" id="modalReactivarForm" name="modalReactivarForm">
    <input type="hidden" name="reactivarJuicioId" id="reactivarJuicioId" value="${juicio.id}"/>
    <input type="hidden" name="reactivarTipoDeParteId" id="reactivarTipoDeParteId" value="${juicio.tipoDeParte.id}"/>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group" id="divEtapasReactivar">
                <label>¿Por que se efectuará el reproceso?</label>
                <div class="input-group">
                    <g:select noSelection="['':'Elija una opción...']" required data-placeholder="Elija una opción..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeReproceso.id" id="tipoDeReproceso" from="${mx.gox.infonavit.sicj.catalogos.TipoDeReproceso.findAllByActivo(true,[sort:'nombre'])}" optionKey="id"/>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group" id="divEtapasReactivar">
                <label>Etapa Procesal</label>
                <div class="input-group">
                    <g:select noSelection="['':'Elija la Etapa Procesal...']" required data-placeholder="Elija la Etapa Procesal..." class="chosen-select" style="width:300px;" tabindex="2" name="etapaProcesal.id" id="etapaProcesal" from="${etapasProcesales*.etapaProcesal}" optionKey="id" onchange = "var tipoDeParte = document.getElementById('reactivarTipoDeParteId').value; ${remoteFunction(controller : 'juicio', action : 'obtenerPreguntasEtapa', params : '\'etapaProcesal=\' + escape(this.value)+ \'&tipoDeParte=\' + tipoDeParte', onSuccess : 'actualizar(data, \'pregunta\')')}" />
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group" id="divPreguntasReactivar">
                <label>Pregunta/Actividad</label>
                <div class="input-group">
                    <select class="chosen-select" id="pregunta" required name="pregunta.id" data-placeholder="Elija primero la Etapa Procesal..." style="width:300px;" tabindex="2">
                    </select>    
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Motivo </label>
                <div class="input-group">
                    <textarea rows="4" cols="80" required style="width: 550px;" id="observaciones" name='observaciones' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Reactivar</button>
            </div>
        </div>
    </div>
</g:form>