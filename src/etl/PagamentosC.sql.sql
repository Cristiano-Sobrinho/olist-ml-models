-- Databricks notebook source
WITH tb_join AS(

  Select t2.*,
          t3.idVendedor

  From silver.olist.pedido AS t1

  LEFT JOIN silver.olist.pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN silver.olist.item_pedido AS t3
  ON T1.idPedido = t3.idPedido

  Where t1.dtPedido < '2018-01-01'
  AND t1.dtPedido >= add_months('2018-01-01', -6)
  AND t3.idVendedor IS NOT NULL

),

tb_group AS(

SELECT idVendedor,
        descTipoPagamento,
        count(distinct idPedido) as qtdPedidoMeioPagamento,
        sum(vlPagamento) as vlPedidoMeioPagamento


FROM tb_join

GROUP BY idVendedor, descTipoPagamento
ORDER BY idVendedor, descTipoPagamento

)

SELECT 
  idVendedor,

  sum(case when descTipoPagamento = 'boleto' then qtdPedidoMeioPagamento else 0 end) as qtde_boleto_pedido, 
  sum(case when descTipoPagamento = 'credit_card' then qtdPedidoMeioPagamento else 0 end) as qtde_credit_card_pedido, 
  sum(case when descTipoPagamento = 'voucher' then qtdPedidoMeioPagamento else 0 end) as qtde_voucher_pedido, 
  sum(case when descTipoPagamento = 'debit_card' then qtdPedidoMeioPagamento else 0 end) as qtde_debit_card_pedido,

  sum(case when descTipoPagamento = 'boleto' then vlPedidoMeioPagamento else 0 end) as valor_boleto_pedido, 
  sum(case when descTipoPagamento = 'credit_card' then vlPedidoMeioPagamento else 0 end) as valor_credit_card_pedido, 
  sum(case when descTipoPagamento = 'voucher' then vlPedidoMeioPagamento else 0 end) as valor_voucher_pedido, 
  sum(case when descTipoPagamento = 'debit_card' then vlPedidoMeioPagamento else 0 end) as valor_debit_card_pedido,
  
  sum(case when descTipoPagamento = 'boleto' then qtdPedidoMeioPagamento else 0 end)/sum(qtdPedidoMeioPagamento) as pct_qtde_boleto_pedido, 
  sum(case when descTipoPagamento = 'credit_card' then qtdPedidoMeioPagamento else 0 end)/sum(qtdPedidoMeioPagamento) as pct_qtde_credit_card_pedido, 
  sum(case when descTipoPagamento = 'voucher' then qtdPedidoMeioPagamento else 0 end)/sum(qtdPedidoMeioPagamento) as pct_qtde_voucher_pedido, 
  sum(case when descTipoPagamento = 'debit_card' then qtdPedidoMeioPagamento else 0 end)/sum(qtdPedidoMeioPagamento) as pct_qtde_debit_card_pedido,

  sum(case when descTipoPagamento = 'boleto' then vlPedidoMeioPagamento else 0 end)/sum(vlPedidoMeioPagamento) as pct_valor_boleto_pedido, 
  sum(case when descTipoPagamento = 'credit_card' then vlPedidoMeioPagamento else 0 end)/sum(vlPedidoMeioPagamento) as pct_valor_credit_card_pedido, 
  sum(case when descTipoPagamento = 'voucher' then vlPedidoMeioPagamento else 0 end)/sum(vlPedidoMeioPagamento) as pct_valor_voucher_pedido, 
  sum(case when descTipoPagamento = 'debit_card' then vlPedidoMeioPagamento else 0 end)/sum(vlPedidoMeioPagamento) as pct_valor_debit_card_pedido


FROM tb_group

GROUP BY 1

-- COMMAND ----------


