<g:if test="${respuesta}">
    <div class="ibox-content" id="ibox-content">
        <g:each var='resp' in='${respuesta}'>
            <div id="vertical-timeline" class="vertical-container dark-timeline">
                <div class="vertical-timeline-block">
                    <div class="vertical-timeline-icon navy-bg">
                        <i class="fa fa-calendar"></i>
                    </div>
                    <div class="vertical-timeline-content">
                        <h4>${resp.estadoDeJuicio}</h4>
                        <p>
                            <b>Observaciones: </b> ${resp.observaciones}
                        </p>
                        <span class="vertical-date">
                            <small>Usuario que modificó: ${resp.usuario}</small> <br/>
                            <small>Fecha del movimiento: ${resp.fechaDeMovimiento}</small>
                        </span>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
</g:if>