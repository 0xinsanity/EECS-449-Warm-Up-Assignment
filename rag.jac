import: py os;
import: py from langchain_community.document_loaders {PyPDFDirectoryLoader}
import: py from langchain_text_splitters {RecursiveCharacterTextSplitter}
import: py from langchain.schema.document {Document}
import: py from langchain_community.embeddings.ollama {OllamaEmbeddings}
import: py from langchain_community.vectorstores.chroma {Chroma}

obj RagEngine {
    has file_path: str = "docs";
    has chroma_path: str = "chroma";

    can load_documents {
        document_loader = PyPDFDirectoryLoader(self.file_path);
        return document_loader.load();
    }

    can split_documents(documents: list[Document]) {
        text_splitter = RecursiveCharacterTextSplitter(chunk_size=800,
        chunk_overlap=80,
        length_function=len,
        is_separator_regex=False);
        return text_splitter.split_documents(documents);
    }

    can get_embedding_function {
        embeddings = OllamaEmbeddings(model='nomic-embed-text');
        return embeddings;
    }

    can add_chunk_id(chunks: str) {
        last_page_id = None;
        current_chunk_index = 0;

        for chunk in chunks {
            source = chunk.metadata.get('source');
            page = chunk.metadata.get('page');
            current_page_id = f'{source}:{page}';

            if current_page_id == last_page_id {
                current_chunk_index +=1;
            } else {
                current_chunk_index = 0;
            }

            chunk_id = f'{current_page_id}:{current_chunk_index}';
            last_page_id = current_page_id;

            chunk.metadata['id'] = chunk_id;
        }

        return chunks;
    }
    
    can get_from_chroma(query: str,chunck_nos: int=5) {
        db = Chroma(
            persist_directory=self.chroma_path,
            embedding_function=self.get_embedding_function()
        );
        results = db.similarity_search_with_score(query,k=chunck_nos);
        return results;
    }
}