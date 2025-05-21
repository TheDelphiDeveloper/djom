# 🧩 DJOM – Declarative JSON-Object Mapper for Delphi

**DJOM** é um mapeador JSON→Object com uma abordagem **declarativa e fluente**, criado para Delphi, que permite definir o relacionamento entre campos JSON e propriedades de objetos de forma expressiva, poderosa e reutilizável.

Inspirado em ferramentas modernas de mapeamento de dados e no poder do RTTI do Delphi, DJOM oferece suporte a:

- ✅ Mapeamento declarativo campo→propriedade
- ✅ Valores padrão (`WithDefault`)
- ✅ Conversores customizados (`WithConverter`)
- ✅ Validações (`Validate`)
- 🚧 Suporte a tipos complexos (em andamento)
- 🚧 Suporte a listas e exportação reversa (em planejamento)
- 🚧 Integração com Spring.Expressions (planejado)

---

## 🚀 Exemplo de uso

```delphi
uses
  DJOM.Mapper;

type
  TUser = class
  public
    UserName: string;
    Age: Integer;
    BirthDate: TDate;
  end;

var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create
    .Field('user_name').ToProp('UserName')
    .Field('age').ToProp('Age').WithDefault(18)
    .Field('birth').ToProp('BirthDate').WithConverter(
      function(const V: TValue): TValue
      begin
        Result := StrToDate(V.AsString);
      end
    ).Validate(
      function(const V: TValue): Boolean
      begin
        Result := V.AsDateTime < Now;
      end
    );

  user := mapper.Apply('{"user_name": "Diego", "birth": "1990-01-01"}');
  ShowMessage(user.UserName);  // Diego
end;
```

---

## 🛠 Instalação

### Opção 1 – Via [Boss](https://github.com/HashLoad/boss)

```bash
boss install github.com/seu-usuario/djom
```

### Opção 2 – Manual

1. Baixe o repositório
2. Adicione a pasta `/Source` ao Library Path do Delphi
3. Use a unit `DJOM.Mapper` nos seus projetos

---

## 📦 Estrutura do Projeto

```
/DJOM
├── Source/
│   ├── DJOM.Mapper.pas          // Core: Interfaces e mapeador
│   ├── DJOM.Types.pas           // Structs e helpers de mapeamento
│   ├── DJOM.Converters.pas      // Converters prontos (em breve)
│   ├── DJOM.Validations.pas     // Validações comuns (em breve)
├── Samples/
│   ├── Sample.Basic.dpr         // Uso básico do DJOM
├── Tests/
│   └── DJOM.Tests.pas           // Testes unitários (DUnitX)
```

---

## 🔧 Métodos disponíveis na DSL

| Método | Descrição |
|--------|-----------|
| `Field(JsonName)` | Inicia o mapeamento de um campo JSON |
| `.ToProp(PropertyName)` | Define a propriedade da classe alvo |
| `.WithDefault(Value)` | Usa valor padrão se o campo JSON estiver ausente |
| `.WithConverter(Func)` | Aplica função de conversão ao valor antes de aplicar |
| `.Validate(Func)` | Valida o valor antes de aplicar – lança exceção se inválido |

---

## 🧪 Testes

- Os testes estão disponíveis em `/Tests/DJOM.Tests.pas`
- Utilize DUnitX para executar os testes automaticamente

---

## 📚 Roadmap

- [x] Mapeamento declarativo básico
- [x] WithDefault
- [x] WithConverter
- [x] Validate
- [ ] Suporte a tipos aninhados (`user.name`)
- [ ] Suporte a listas
- [ ] Object → JSON (exportação reversa)
- [ ] Suporte a atributos `[JsonField(...)]`
- [ ] Integração com `Spring.Expressions`
- [ ] Boss package no registry oficial

---

## 🤝 Contribuições

Contribuições são muito bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie sua branch: `git checkout -b minha-feature`
3. Commit suas alterações: `git commit -m 'Adiciona nova funcionalidade'`
4. Push para sua branch: `git push origin minha-feature`
5. Abra um Pull Request

---

## 📄 Licença

Este projeto é licenciado sob a **MIT License** – veja o arquivo `LICENSE` para detalhes.

---

## ✉️ Contato

Criado por [Diego Ernani](https://www.linkedin.com/in/diegoernani) – mantenedor do canal *The Delphi Developer*.
