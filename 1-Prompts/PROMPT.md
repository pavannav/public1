- Use GitHub-flavored Markdown
- Keep it simple - no fancy styling
- Use code blocks for flow diagrams (they have dark background):
```
   Client Request → Node → Kube Proxy → Pod
```
- Use > [!IMPORTANT] or > [!NOTE] for highlighting key points
- Use emojis for visual markers: ✅ ❌ 💡 ⚠ 📝
- Follow the same structure/order as the instructor
- For new terms and definitions, use a textbook style explanation or as it is defined in the course.
- 
- Represent diagramatically where ever possible
- For important points, use diff blocks with colored backgrounds:

Use Linear for:
- Sequential processes (A → B → C)
- Before/after comparisons
- Simple workflows
Example:
```diff
! Client Request → Node → Kube Proxy → [Routing Logic] → Correct Pod
```

```
OLD (High Latency):
Kubernetes → Docker CLI → Docker Daemon → containerd → Container
     ↑                                         ↑
  Request                              Actual Work Done
```

Use Structural for:
- Architecture
- Multiple relationships
- Hierarchical structures
Example:

                 kubectl/API calls
                           ↓
                    ┌──────────────┐
                    │Load Balancer │
                    └──────────────┘
                           ↓
        ┌──────────────────┼──────────────────┐
        ↓                  ↓                   ↓
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│Control Plane 1│  │Control Plane 2│  │Control Plane 3│
└───────────────┘  └───────────────┘  └───────────────┘
        ↓                  ↓                   ↓
        └──────────────────┼───────────────────┘
                           ↓
                ┌──────────┴──────────┐
                ↓                     ↓
        ┌───────────────┐     ┌───────────────┐
        │Compute Node 1 │     │Compute Node 2 │
        └───────────────┘     └───────────────┘
