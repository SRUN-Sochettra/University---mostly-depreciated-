# Contributing

Treat this repository as a collection of independent coursework projects. Make changes inside the relevant project and avoid repository-wide refactors that blur ownership, dependencies or assignment history.

## Scope changes carefully

State the exact project, course exercise and files affected. Preserve assignment requirements and historical artefacts unless the change explicitly retires or relocates them. Do not silently replace a submodule with copied source or vice versa.

Use the project's own formatter, analyser, tests and build commands. A successful check in one Flutter or web project says nothing about sibling projects. Report exact commands and target platforms; distinguish syntax checks, mocked tests, emulator runs and real-device/browser verification.

Avoid adding real credentials, private student records or account data. Use synthetic values in screenshots and examples. Review external API terms and instability before relying on live responses in assessed work.

## Pull requests

Explain the assignment/project, problem, smallest change, checks actually run and remaining gaps. Keep generated build outputs and unrelated formatting churn out of focused changes. Follow [SECURITY.md](SECURITY.md) for sensitive reports.
