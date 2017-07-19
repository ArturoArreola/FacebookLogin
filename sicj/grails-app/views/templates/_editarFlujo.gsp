<center>
    <div class="alert alert-info text-justify">
        <strong>Importante:</strong> Sólo tendrá posibilidad de editar la última versión de la pregunta que elija, es decir, si la pregunta tiene más de una respuesta dada, sólo podrá modificarse la última de ellas.
    </div>
</center>
<g:form action="editarFlujoJuicio" method="POST" id="modalEditarFlujoForm" name="modalEditarFlujoForm">
    <input type="hidden" name="reactivarJuicioId" id="reactivarJuicioId" value="${juicio.id}"/>
    <input type="hidden" name="reactivarTipoDeParteId" id="reactivarTipoDeParteId" value="${juicio.tipoDeParte.id}"/>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group" id="divEtapasReactivar">
                <label>Etapa Procesal</label>
                <div class="input-group">
                    <g:select noSelection="['':'Elija la Etapa Procesal...']" required data-placeholder="Elija la Etapa Procesal..." class="chosen-select" style="width:300px;" tabindex="2" name="etapaProcesal.id" id="etapaProcesal" from="${etapasProcesales*.etapaProcesal}" optionKey="id" onchange = "var tipoDeParte = document.getElementById('reactivarTipoDeParteId').value; ${remoteFunction(controller : 'juicio', action : 'obtenerPreguntasEtapa', params : '\'etapaProcesal=\' + escape(this.value)+ \'&tipoDeParte=\' + tipoDeParte', onSuccess : 'actualizar(data, \'preguntaAEditar\')')}" />
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group" id="divPreguntasEditar">
                <label>Pregunta/Actividad</label>
                <div class="input-group">
                    <select class="chosen-select" id="preguntaAEditar" required name="pregunta.id" data-placeholder="Elija primero la Etapa Procesal..." style="width:300px;" tabindex="2" onchange = "buscarRespuestasDePregunta(escape(this.value));">
                    </select>    
                </div>
            </div>
        </div>
    </div>
    <div id="respuestaAEditar"></div>
</g:form>