import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

// import 'package:prova_pratica_dart/prova_pratica_dart.dart'
//    as prova_pratica_dart;

class Curso {
  late int id;
  String descricao = "";
  List<Aluno> alunos = [];
  List<Professor> professores = [];
  List<Disciplina> disciplinas = [];

  Curso(this.id);

  void adicionarProfessor(Professor professor) {
    professores.add(professor);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "descricao": descricao,
        "alunos": alunos.map((aluno) => aluno.toJson()).toList(),
        "professores":
            professores.map((professor) => professor.toJson()).toList(),
        "disciplinas":
            disciplinas.map((disciplina) => disciplina.toJson()).toList(),
      };
}

class Professor {
  late int id;
  late String codigo;
  late String nome;

  Professor(this.id, this.nome, this.codigo);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "codigo": codigo,
      };
}

class Disciplina {
  late int id;
  String descricao = "";
  late int qtdAulas;

  Disciplina(this.id, this.qtdAulas);

  Map<String, dynamic> toJson() => {
        "id": id,
        "descricao": descricao,
        "qtdAulas": qtdAulas,
      };
}

class Aluno {
  late int id;
  late String nome;
  late String matricula;

  Aluno(this.id, this.nome, this.matricula);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "matricula": matricula,
      };
}

void main(List<String> arguments) async {
  Curso informatica = Curso(8);
  informatica.descricao = "Um curso para computadores";

  Disciplina pdm = Disciplina(1, 40);
  Disciplina pweb = Disciplina(2, 80);
  pdm.descricao = "Programação para dispositivos móveis";
  pweb.descricao = "Programação web";

  Professor taveira = Professor(1, "taveira", "Quishx87S");
  Professor jose = Professor(2, "José Roberto", "8SY749xsga8");

  Aluno eu = Aluno(1, "João Pedro", "20312909431");
  Aluno voce = Aluno(2, "Fulano", "dfuashcsaQDq");
  Aluno ele = Aluno(3, "Cicrano", "DSA&g");

  informatica.adicionarDisciplina(pdm);
  informatica.adicionarDisciplina(pweb);
  informatica.adicionarProfessor(taveira);
  informatica.adicionarProfessor(jose);
  informatica.adicionarAluno(eu);
  informatica.adicionarAluno(voce);
  informatica.adicionarAluno(ele);

  var json = jsonEncode(informatica.toJson());

  final arquivo = File('curso.json');
  await arquivo.writeAsString(json);

  final smtpServer =
      gmail('joao.andrade09@aluno.ifce.edu.br', 'uplj hmee vmdc qdwc');

  final message = Message()
    ..from = Address('joao.andrade09@aluno.ifce.edu.br', 'eu')
    ..recipients.add('taveira@ifce.edu.br')
    ..subject = 'prova'
    ..text = "Prova do aluno João Pedro de Andrade Holanda"
    ..attachments = [
      FileAttachment(arquivo)
        ..location = Location.attachment
        ..fileName = 'curso.json'
    ];

  try {
    final sendReport = await send(message, smtpServer);

    print("E-mail enviado");
  } on MailerException catch (e) {
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}
