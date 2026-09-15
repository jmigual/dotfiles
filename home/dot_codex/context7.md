1. Start with `resolve-library-id` using the library name and the user's question,
   unless an exact `/org/project` library ID is already provided.
2. Choose by name, relevance, source reputation, snippet coverage, and benchmark
   score. Try another name or query if the matches are poor. Use a version-specific
   ID when a version was requested.
3. Call `query-docs` with the selected ID and the complete question.
4. Answer using the fetched documentation.
