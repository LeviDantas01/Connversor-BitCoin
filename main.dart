import 'dart:convert';
import 'package:conversor_moedas/input.dart';
import 'package:conversor_moedas/web/web_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=YOUR_API_KAY";

void main() async {
  runApp(
    MaterialApp(
      home: const Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realConttroler = TextEditingController();
  final dolarConttroler = TextEditingController();
  final euroConttroler = TextEditingController();
  final bitCoinConttroler = TextEditingController();

  double? dolar;
  double? euro;
  double? bitCoin;

  void _realMudou(String text) {
    double real = double.parse(text);
    dolarConttroler.text = (real / dolar!).toStringAsFixed(2);
    euroConttroler.text = (real / euro!).toStringAsFixed(2);
    bitCoinConttroler.text = (real / bitCoin!).toStringAsFixed(2);
  }

  void _dolarMudou(String text) {
    double dolar = double.parse(text);
    realConttroler.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroConttroler.text = (dolar * this.dolar! / euro!).toStringAsFixed(2);
    bitCoinConttroler.text =
        (dolar * this.dolar! / bitCoin!).toStringAsFixed(2);
  }

  void _euroMudou(String text) {
    double euro = double.parse(text);
    realConttroler.text = (euro * this.euro!).toStringAsFixed(2);
    dolarConttroler.text = (euro * this.euro! / dolar!).toStringAsFixed(2);
    bitCoinConttroler.text = (euro * this.euro! / bitCoin!).toStringAsFixed(2);
  }

  void _bitCoinMudou(String text) {
    double bitCoin = double.parse(text);
    realConttroler.text = (bitCoin * this.bitCoin!).toStringAsFixed(2);
    dolarConttroler.text =
        (bitCoin * this.bitCoin! / dolar!).toStringAsFixed(2);
    euroConttroler.text = (bitCoin * this.bitCoin!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("\$Conversor de Moedas\$"),
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        "Carregando dados",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ],
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Erro ao carregar dados",
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  bitCoin =
                      snapshot.data!["results"]["currencies"]["BTC"]["buy"];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool? result = await dialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Consulte as cotações aqui",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        buildTextFild(
                            "Reais", "R\$", realConttroler, _realMudou),
                        const Divider(),
                        buildTextFild(
                            "Dolar", "UR\$", dolarConttroler, _dolarMudou),
                        const Divider(),
                        buildTextFild("Euros", "€", euroConttroler, _euroMudou),
                        const Divider(),
                        buildTextFild(
                            "BitCoin", "₿", bitCoinConttroler, _bitCoinMudou),
                        const Divider(),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              limpar();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Limpar",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Future<bool?> dialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Qual site deseja ir ?"),
            actions: [
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      String url =
                          "https://www.infomoney.com.br/cotacoes/cripto/ativo/bitcoin-btc/";
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (c) {
                            return WebViewApp(
                              url: url,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text("Cotação do BitCoin para real"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      String url =
                          " https://www.moneytimes.com.br/cotacao/bitcoin-us/";
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (c) {
                            return WebViewApp(url: url);
                          },
                        ),
                      );
                    },
                    child: const Text("Cotação do BitCoin para dolar"),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void limpar() {
    setState(() {
      realConttroler.text = "";
      dolarConttroler.text = "";
      euroConttroler.text = "";
      bitCoinConttroler.text = "";
    });
  }
}
