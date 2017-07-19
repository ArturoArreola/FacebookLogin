<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <g:form id="modalNotasForm" name="modalNotasForm" class="form-horizontal">
                    <div id="divResultadoAlta">
                    
                    </div>
                    <input type="hidden" name="juicio" id="juicio" value="${juicio?.id}">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">Nota: </label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <textarea required rows="4" cols="80" style="width: 365px;" id="notaJuicio" name='notaJuicio' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                            </div> 
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-4 col-sm-offset-2">
                            <g:submitToRemote onSuccess="limpiarFormulario('modalNotasForm')" onFailure="alert('algo fallo')" update="divResultadoAlta" class="btn btn-primary" url="[controller: 'juicio',action: 'agregarNota']" method="POST" value="Guardar"/>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>