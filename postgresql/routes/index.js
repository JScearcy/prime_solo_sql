var express = require('express');
var router = express.Router();
var pg = require('pg');
var connect = process.env.DATABASE_URL || 'postgres://localhost:5432/customer_information';

router.get('/custinfo', function(req, res, next) {
  var results = [];
  pg.connect(connect, function(err, client, done) {
      var query = client.query("SELECT orders.order_id, \
                                products.product_name, \
                                products.product_price, \
                                orders.product_amount, \
                                orderid_custid.customer_id, \
                                customers.name \
                                FROM orders \
                                JOIN products \
                                ON orders.product_id = products.product_id \
                                JOIN orderid_custid \
                                ON orders.order_id = orderid_custid.order_id \
                                JOIN customers \
                                ON customers.cust_id = orderid_custid.customer_id");
      query.on('row', function(row) {
          results.push(row);
      });
      query.on('end', function() {
          client.end();
          var lastProduct;
          var newResults = {};
          results.forEach(function(product, index){
            if (product.order_id != lastProduct){
              newResults[product.order_id] =  {order: [product]};
              newResults[product.order_id].price =  product.product_price * product.product_amount;
              lastProduct = product.order_id;

            } else {
              newResults[product.order_id].order.push(product);
              newResults[product.order_id].price = newResults[product.order_id].price + product.product_price * product.product_amount;
            }
          });
          console.log(newResults);
          res.render('index', { results: newResults });
      });
      if(err) {
          console.log(err);
      }

  });
});

module.exports = router;
