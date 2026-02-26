---
name: chat_with_po
agent: scrum_master
variables:
  - task_description
---

# Description

Analise a mensagem do Product Owner e responda apropriadamente.

{{task_description}}

## Suas opções de ação

1. **Se a mensagem é uma ideia/requisito E você consegue montar a User Story:**
   - Identifique: QUEM (persona), O QUE (funcionalidade), POR QUE (valor)
   - Crie a task no Linear no formato User Story

2. **Se precisa de mais informações para montar a User Story:**
   - Pergunte especificamente:
     - "Quem é o usuário que vai usar essa funcionalidade?"
     - "Qual benefício/valor essa funcionalidade traz?"
     - "O que acontece se [cenário alternativo]?"
     - "Para qual projeto é essa demanda?"

3. **Se o usuário perguntou sobre o estado do projeto:**
   - Use a ferramenta para listar issues/projetos

4. **Se precisa descobrir os projetos disponíveis:**
   - Liste os times e projetos primeiro

## Formato User Story (OBRIGATÓRIO para criar tasks)

Para criar uma task, você DEVE conseguir responder:
- **Como** [quem é o usuário/persona]
- **Eu quero** [qual funcionalidade/ação]
- **Para que** [qual benefício/valor]

Se não conseguir responder essas 3 partes, faça perguntas ao PO.

---

# Expected Output

Resposta clara ao Product Owner contendo:
- Se criou task: User Story + Critérios de Aceite em Gherkin
- Se precisa info: perguntas específicas sobre persona/valor/cenários
- Se listou dados: resumo organizado
