# Regras e Padrões de Frontend (React + Inertia + Shadcn)

Este arquivo define os limites e as práticas recomendadas na engenharia de frontend dentro deste Boilerplate. Todo desenvolvimento cliente-servidor UI/UX deve seguir esses princípios rigorosamente.

## 1. Stack Base
- **React 18**: Use Functional Components sempre.
- **Inertia.js**: Trata as chamadas do Laravel SSR -> React. NUNCA faça requisições AJAX (`fetch`/`axios`) se for navegação ou envio de formulated standard; use os links e forms do `@inertiajs/react` (`useForm`, `<Link>`).
- **Tailwind CSS + Shadcn UI**: Sem arquivos CSS adicionais, exceto `app.css` base. Para componentes novos de UI, priorize buscar se um `Button`, `Dialog` do Shadcn já atende antes de construir customizado.

## 2. Estrutura de Pastas e Componentes
- `resources/js/Pages/`: Telas e roteáveis do sistema. Todo arquivo base aqui deve carregar um layout (ex: `<AuthenticatedLayout>`).
- `resources/js/Components/ui/`: Diretório EXCLUSIVO para componentes gerados pelo CLI do Shadcn (`npx shadcn@latest add`).
- `resources/js/Components/`: Componentes customizados globais e de domínio específicos da aplicação.

## 3. Práticas e Linter
- Utilize TypeScript/JSDoc types quando aplicável.
- Respeite a exportação default para Pages (exigência do Inertia page loader).
- Evite props drilling excessivo; React Context pode ser usado com cautela, mas o Inertia Page Props (`usePage()`) normalmente é o provedor de variáveis globais injetadas pelo Laravel (ex: dados do Auth User).

## 4. Animações
- Utilize as classes do `tailwindcss-animate` injetadas ou as primitivas do Framer Motion caso sejam inclusas em complexidades futuras.
