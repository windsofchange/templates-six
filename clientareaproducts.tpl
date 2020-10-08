{include file="$template/includes/tablelist.tpl" tableName="ServicesList" filterColumn="4" noSortColumns="0"}
<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableServicesList').removeClass('hidden').DataTable();
        {if $orderby == 'product'}
            table.order([1, '{$sort}'], [4, 'asc']);
        {elseif $orderby == 'amount' || $orderby == 'billingcycle'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'nextduedate'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'domainstatus'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>
<div class="table-container clearfix">
    <table id="tableServicesList" class="table table-list hidden">
        <thead>
            <tr>
                <th></th>
                <th>{$LANG.orderproduct}</th>
                <th>{$LANG.clientareaaddonpricing}</th>
                <th>{$LANG.clientareahostingnextduedate}</th>
                <th>{$LANG.clientareastatus}</th>
                <th class="responsive-edit-button" style="display: none;"></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            {foreach key=num item=service from=$services}
            {if $service.status eq "Active" or $service.status eq "Suspended" or $service.status eq "Pending"}
              {if $service.group eq "SSL Certificates"}
                <tr>
                    <td class="text-center" data-element-id="{$service.id}" data-type="service"{if $service.domain} data-domain="{$service.domain}"{/if}>
                        <img src="assets/img/ssl/ssl-active.png" data-toggle="tooltip" title="{$service.status}" class=""/>
                    </td>
                {else}
                <tr onclick="clickableSafeRedirect(event, 'clientarea.php?action=productdetails&amp;id={$service.id}', false)">
                    <td class="text-center{if $service.sslStatus} ssl-info{/if}" data-element-id="{$service.id}" data-type="service"{if $service.domain} data-domain="{$service.domain}"{/if}>
                        {if $service.sslStatus}
                            <img src="{$service.sslStatus->getImagePath()}" data-toggle="tooltip" title="{$service.sslStatus->getTooltipContent()}" class="{$service.sslStatus->getClass()}"/>
                        {elseif !$service.isActive}
                            <img src="{$BASE_PATH_IMG}/ssl/ssl-inactive-domain.png" data-toggle="tooltip" title="{lang key='sslState.sslInactiveService'}">
                        {/if}
                    </td>
                {/if}
             <!--       <td><strong>{$service.product}</strong>{if $service.domain}<br /><a href="http://{$service.domain}" target="_blank">{$service.domain}</a>{/if}</td> -->
                    <td><strong>{$service.product}</strong>
                        {if $service.group eq "SSL Certificates"}
                            <br/>{$service.group}
                        {/if}
                        {if $service.domain}<br /><span style="font-size:0.95em"><i class="glyphicon glyphicon-globe"></i> {$service.domain}<br/>
                            {if $service.server.hostname}
                                <i class="glyphicon glyphicon-tasks"></i> {$service.server.hostname} {$service.server.ipaddress}
                            {/if}</span>
                        {/if}
                    </td>
                    {if $service.status eq "Active" or $service.status eq "Suspended"}
                        <td class="text-center" data-order="{$service.amountnum}">{$service.amount}<br />{$service.billingcycle}</td>
                        <td class="text-center"><span class="hidden">{$service.normalisedNextDueDate}</span>{$service.nextduedate}</td>
                    {else}
                        <td class="text-center" data-order="{$service.amountnum}"></td>
                        <td class="text-center"></td>
                    {/if}
                    <td class="text-center"><span class="label status status-{$service.status|strtolower}">{$service.statustext}</span></td>
                    <td class="responsive-edit-button" style="display: none;">
                        <a href="clientarea.php?action=productdetails&amp;id={$service.id}" class="btn btn-block btn-info">
                            {$LANG.manageproduct}
                        </a>
                    </td>
                    <!-- add details icon -->
                    <td><a href="clientarea.php?action=productdetails&id={$service.id}" class="btn btn-default"><i class="fas fa-wrench"></i></a></td>
                    <!-- End add details icon -->
                </tr>
             {/if}
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>
    {include file="$template/includes/alert.tpl" type="warning" msg=$LANG.activeproductlistingonly}
