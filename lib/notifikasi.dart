import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';

void main() {
  runApp(notifikasi());
}

class notifikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product Cards'),
        ),
        body: ProductCardGrid(),
      ),
    );
  }
}

/* CLASS PRODUK */
class Product {
  final String title;
  final String description;
  final String imageUrl;

  Product({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
/* CLASS PRODUK */

/* LIST PRODUK */
List<Product> productList = [
  Product(
    title: 'Product 1',
    description: 'Description of Product 1',
    imageUrl:
        'https://static.designboom.com/wp-content/uploads/2020/07/kfc-bioprinting-meat-future-designboom-500.jpg',
  ),
  Product(
    title: 'Product 1',
    description: 'Description of Product 1',
    imageUrl:
        'https://static.designboom.com/wp-content/uploads/2020/07/kfc-bioprinting-meat-future-designboom-500.jpg',
  ),
  Product(
    title: 'Product 1',
    description: 'Description of Product 1',
    imageUrl:
        'https://static.designboom.com/wp-content/uploads/2020/07/kfc-bioprinting-meat-future-designboom-500.jpg',
  ),
  Product(
    title: 'Product 1',
    description: 'Description of Product 1',
    imageUrl:
        'https://static.designboom.com/wp-content/uploads/2020/07/kfc-bioprinting-meat-future-designboom-500.jpg',
  ),
  Product(
    title: 'Product 1',
    description: 'Description of Product 1',
    imageUrl:
        'https://static.designboom.com/wp-content/uploads/2020/07/kfc-bioprinting-meat-future-designboom-500.jpg',
  ),
  // Add more products as needed
];
/* LIST PRODUK */

class ProductCardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      /* shrinkWrap: true, */
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display 2 products per row
      ),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        return ProductCard(product: productList[index]);
      },
    );
  }
}

/* UI CARD */
class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 252, 237, 241)),
        ),
        onPressed: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://www.everydayonsales.com/wp-content/uploads/2022/06/KFC-Nasi-Lemak-Deal.jpg',
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'KFC Nasi Lemak',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'URW',
                          color: Warna.TextBold,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rp. 2000',
                      style: TextStyle(
                          fontFamily: 'URW',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Warna.Primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                /* SUKAI */
                GestureDetector(
                  onTap: () {
                    print('LIKED');
                  },
                  child: Icon(
                    Icons.favorite_outline,
                    color: Warna.Primary,
                  ),
                ),
                /* SUKAI */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/* UI CARD */
