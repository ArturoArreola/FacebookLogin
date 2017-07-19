<div class="ibox">
    <div class="ibox-content">
        <ul class="sortable-list connectList agile-list">
            <g:each var='pago' in='${pagosDeRezago}'>
                <li class="<g:if test="${pago.numeroDePago == 1}">info-element</g:if><g:if test="${pago.numeroDePago == 2}">success-element</g:if><g:if test="${pago.numeroDePago == 3}">warning-element</g:if><g:if test="${pago.numeroDePago == 4}">danger-element</g:if>">
                    <strong> Pago No. ${pago.numeroDePago}</strong> por: <g:formatNumber number="${pago.montoDelPago}" format="\044###,##0"/> <br/>
                    <strong> Fecha de Pago: </strong> <g:formatDate format="dd/MM/yyyy" date="${pago.fechaDelPago}" />
                    <div class="agile-detail">
                        <a class="pull-right btn btn-xs btn-white">${pago.usuarioQueRegistro}</a>
                        <i class="fa fa-clock-o"></i> Registrado el: <g:formatDate format="dd/MM/yyyy HH:mm" date="${pago.fechaDeRegistro}" />
                    </div>
                </li>
            </g:each>
        </ul>
    </div>
</div>