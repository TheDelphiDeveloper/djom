
# Changelog

## [0.2.0] - 2024-05-15

### ✨ Adicionado

- 🔁 **ToJson**: suporte completo à serialização de objetos Delphi para JSON, com base em RTTI
- 🧾 **Suporte a listas (`TList<T>`)**: mapeamento automático de arrays JSON para propriedades `TList<string>`
- 🔄 Conversão automática de arrays JSON declarados como string (`"[...]"`) para `TJSONArray`
- 🧠 `ExtractNestedValue` agora interpreta corretamente arrays serializados como texto

### 🧼 Melhorado

- 🔍 `JsonToTValue`: agora interpreta `Integer`, `Double`, `Boolean` e `String` com precisão
- 🔐 Mais segurança no `Apply(...)` ao usar RTTI para instanciar listas
- 📥 Bloco `Apply` reformulado com detecção e preenchimento seguro de listas

### ✅ Compatibilidade

- Delphi XE7 ou superior
- Requer **Spring4D**
- Compatível com objetos que possuam listas internas ou campos aninhados

---

> Essa versão marca o início do suporte bidirecional no DJOM: JSON → Object e agora Object → JSON, com leitura e escrita fluente.


## [0.1.1] - 2024-05-15
### Corrigido
- Conversão segura de tipos JSON (Boolean, Number) usando `JsonToTValue`
- Substituição de `FromVariant` por detecção real do tipo via RTTI

## [0.1.0] - 2025-05-15
### Adicionado
- Mapeamento fluente: `Field(...).ToProp(...)`
- Conversores com `WithConverter(...)`
- Valores padrão com `WithDefault(...)`
- Validações com `Validate(...)`
- Suporte a campos aninhados como `user.endereco.cidade`
- Testes reais com botões em formulário VCL

### Corrigido
- Erro de cast ao mapear campos booleanos (`Invalid class typecast`)
- Conversão segura de tipos a partir de `TJSONValue` usando `JsonToTValue(...)`

### Compatibilidade
- Requer Delphi XE7 ou superior
- Requer Spring4D (instalável via Boss)

---

Este é o primeiro release público do DJOM – Declarative JSON-Object Mapper for Delphi.
