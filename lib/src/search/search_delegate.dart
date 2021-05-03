import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Spiderman',
    'Spiderman',
    'Spiderman',
    'Spiderman',
  ];
  final peliculasRecientes = [
    'Spiderman',
    'Batman',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones del Appbar (como limpiar o cancelar la busqueda)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          //Limpia la búsqueda
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Lo que aparece al iniio
    //Icono a la izquierda del Appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Metodo de Search Delegate
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Builder (Creador) de los resultados que se van a mostrar
    //Para interactuar más con la busqueda
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map<Widget>((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(pelicula.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  //Cerrar la busqueda
                  close(context, null);
                  //Navegar
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    //Codigo no usado, pero util para poder mostrar sugeridos y resultados
    /* final listaSugerida = (query.isEmpty)
        //Si no ha escrito nada, muestro recientes
        ? peliculasRecientes
        //Si ha escrito, hago la lista con los resultados que empiecen con lo del query
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    //Sugerencias cuando se escribe algo
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            //Metodo del Search Delegate
            showResults(context);
          },
        );
      },
    ); */
  }
}
