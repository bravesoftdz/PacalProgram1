
//PAREI RENOMEANDO OS ARQUIVOS TEMP PRO ARQUIVO ORIGINAL
program Rhany;
Uses
Crt, DOS, sysutils;

Type TLeitor= Record
	cod:Integer;
	Nome:String[100];
	Tipo:String[11];
	TotLivros:Integer;
	AnoCadas:Integer;
	end;

	Type TLivro= Record
	Nome: String[50];
	cod: Integer;
	Classificacao: String[50];
	Autor: String[50];
	Editora: String[50];
        Basico: Integer;
        Emprestado: Integer;
        Data_Emprestimo: Integer;
	end;

var resposta: Integer; resp2: Integer;
	teste: Integer;
	Leitor: TLeitor;
	ArqLeitor: File of TLeitor;
	ArqTempLeitor: File of TLeitor;
	Leitor_Encont: TLeitor;
	Livro: TLivro;
	ArqLivro: File of TLivro;
	ArqTempLivro: File of TLivro;
	Livro_Encontrado: TLivro;
	i: Integer;
	j: Integer;
	k: Longint;
	proxCodLivro: Integer;
	codEmpresLeitor: Integer;
	codEmpresLivro: Integer;
	Ano, Mes, Dia, Dia_Semana: Word;
	parameters: Integer;

function Novo_Leitor():Integer;
begin
	ClrScr;
	i := 0;
	Assign (ArqLeitor, 'Leitores.ARQ');
	{$I-}
	Reset (ArqLeitor);
	Seek(ArqLeitor, FileSize(ArqLeitor));
	{$I+}

	if IORESULT() <> 0 then ReWrite(ArqLeitor);

	writeln('Codigo do Leitor:'); readln(Leitor.cod);
	writeln('Nome do Leitor:'); readln(Leitor.Nome);
	writeln('Tipo do Leitor:'); readln(Leitor.Tipo);


GetDate(Ano,
Mes,
Dia,
Dia_Semana);



	Leitor.AnoCadas := Ano;
	Leitor.TotLivros := 0;
	Seek(ArqLeitor, FileSize(ArqLeitor));
	Write(ArqLeitor, Leitor);
	Close(ArqLeitor);
	writeln('Leitor adicionado com Sucesso! Entre com um dado para voltar ao menu: ');
		read(j);

 end;

function Novo_Livro():Integer;
begin
        ClrScr;
        proxCodLivro := 1;
        Assign(ArqLivro, 'Livros.ARQ');
        {$I-}
        Reset (ArqLivro);
        Seek(ArqLivro, FileSize(ArqLivro));
        {$I+}
        if IORESULT()<>0 then begin ReWrite(ArqLivro);  end; 
         	i := 1;		
         					
		writeln('Entre com qualquer dado para continuar:'); readln(j);
		writeln('Nome do Livro:'); readln(Livro.Nome);
		writeln('Codigo do Livro:'); readln(Livro.cod);
		writeln('Classificacao do Livro:'); readln(Livro.Classificacao);
        writeln('Autor do Livro:'); readln(Livro.Autor);
        writeln('Editora do Livro:'); readln(Livro.Editora);
        writeln('O livro e texto basico de algum curso da instituicao? (1 - SIM ou 2 - NAO):'); readln(resp2);
        Livro.Emprestado := 0;
        Livro.Data_Emprestimo := 0;
        if resp2 = 1 then
        begin
        	Livro.Basico := 1;
        end

        else
        begin
        	Livro.Basico := 0;
        end;
	Seek(ArqLivro, FileSize(ArqLivro));
        Write(ArqLivro, Livro);
		Close(ArqLivro);
		writeln('Livro adicionado com Sucesso! Entre com um dado para voltar ao menu: ');
		read(j);
end;

function AnotaLivro(codEmpresLivro:Integer):Integer;
begin
	ClrScr;

        Assign (ArqLivro,'Livros.ARQ');
        Assign (ArqTempLivro,'LivrosTemp.ARQ');
  {$I-}
  Reset (ArqLivro);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqLivro);

   {$I-}
  Reset (ArqTempLivro);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqTempLivro);

  Seek (ArqLivro,0);
  Seek (ArqTempLivro, FileSize(ArqTempLivro));

  While (Not(Eof(ArqLivro))) Do
  Begin
  	Read(ArqLivro, Livro);

	  if(Livro.cod = codEmpresLivro)
	  then 
	  begin
	  	Livro_Encontrado := Livro;
	 end

		 else
		 begin 
		 	Seek(ArqTempLivro, FileSize(ArqTempLivro));
		 	Write(ArqTempLivro, Livro);
		  end;

   end;

   if ((Livro_Encontrado.Basico = 1) or (Livro_Encontrado.Emprestado = 1)) then
				   	begin
				   		Close(ArqLivro);
				   		Close(ArqTempLivro);
				   		AnotaLivro:= 0;
				   	end

	else
	begin
	GetDate(Ano,
Mes,
Dia,
Dia_Semana);



		Livro_Encontrado.Emprestado := 1;
		Livro.Data_Emprestimo := Dia;
		Seek(ArqTempLivro, FileSize(ArqTempLivro));
   	Write (ArqTempLivro,Livro_Encontrado);
   	Close(ArqLivro);
   	Erase(ArqLivro);
   	Close(ArqTempLivro);
   	Exec('C:\Projects\prompt\Rename_Livros.bat', 'parameters');
   	AnotaLivro:= 1;

	end;

end;

function Saida_Livro():Integer;
begin
		 ClrScr;
        writeln('Cod. do Leitor a emprestar:'); readln(codEmpresLeitor);
        writeln('Cod. do Livro a emprestar:'); readln(codEmpresLivro);

        Assign (ArqLeitor,'Leitores.ARQ');
        Assign (ArqTempLeitor, 'LeitoresTemp.ARQ');
  {$I-}
  Reset (ArqLeitor);
  {$I+}

  if IORESULT()<>0 then
  begin WriteLn('Nao ha Leitor Cadastrado') end

	else //se existir leitores
	begin
		
	
   {$I-}
  Reset (ArqTempLeitor);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqTempLeitor);

  Seek (ArqLeitor,0);
  Seek (ArqTempLeitor, FileSize(ArqTempLeitor));


		  While (Not(Eof(ArqLeitor)))Do
		 	 Begin
		  			Read (ArqLeitor,Leitor);
				  	if(Leitor.cod = codEmpresLeitor) 
				  	then begin
				  	 
				  		Leitor_Encont := Leitor;
				  	 end

				  	 else	
				  	 begin
				  	 		Seek(ArqTempLeitor, FileSize(ArqTempLeitor));
				   		   Write (ArqTempLeitor, Leitor);
				  		end;


				end;


			   if (AnsiCompareText(Leitor_Encont.Tipo, 'Professor') <> 0) then //se for professor
					   begin

							   	if Leitor.TotLivros >= 8 then
							   	begin
							   		writeln('Esse leitor atingiu o numero maximo de 8 livros emprestados!');
							   	end

							   	else // se nao for maior ou igual a 8
							   	begin
							   		Leitor_Encont.TotLivros := Leitor_Encont.TotLivros + 1;
							   		Seek(ArqTempLeitor, FileSize(ArqTempLeitor));
							   		Write(ArqTempLeitor, Leitor_Encont);
							   		Close(ArqLeitor);
							   		Close(ArqTempLeitor);

							   		if(AnotaLivro(codEmpresLivro) = 1) then begin
							   		Erase(ArqLeitor);
							   		Exec('C:\Projects\prompt\Rename_Leitores.bat', 'parameters');
							   		writeln('Emprestimo anotado com sucesso!');
							   		end

							   		else
							   		begin
							   			Erase(ArqTempLeitor);
							   			writeln('Este livro nao pode ser emprestado! Verifique se o livro é texto base de algum curso da instituicao ou se ja foi emprestado!');
							   		end;

							   		
							   		
							   	end; // se nao for maior ou igual a 8
					   end //se nao for professor

					   else //se for professor
							   	begin
							   		Leitor_Encont.TotLivros := Leitor_Encont.TotLivros + 1;
							   		Seek(ArqTempLeitor, FileSize(ArqTempLeitor));
							   		Write(ArqTempLeitor, Leitor_Encont);
							   		Close(ArqLeitor);
							   		Close(ArqTempLeitor);

							   		if(AnotaLivro(codEmpresLivro) = 1) then begin
							   		Erase(ArqLeitor);
							   		Exec('C:\Projects\prompt\Rename_Leitores.bat', 'parameters');
							   		writeln('Emprestimo anotado com sucesso!');
							   		end

							   		else
							   		begin
							   			Erase(ArqTempLeitor);
							   			writeln('Este livro nao pode ser emprestado! Verifique se o livro é texto base de algum curso da instituicao ou se ja foi emprestado!');
							   		end;

							   		
							   		
							   	end; //se nao for professor

		 end; //se existir leitores

		  writeln('Entre com qualquer dado para continuar');
					   readln(j);


end;

function Exclui_Leitor(codEmpresLeitor:Integer):Integer;
begin
       ClrScr;
       WriteLn('Exclui leitor func =======');
       if codEmpresLeitor = 0 then
       begin
       	writeln('Cod. do Leitor a excluir:'); readln(codEmpresLeitor);
       end;

        Assign (ArqLeitor,'Leitores.ARQ');
        Assign (ArqTempLeitor, 'LeitoresTemp.ARQ');
  {$I-}
  Reset (ArqLeitor);
  {$I+}

  if IORESULT()<>0 then
  begin WriteLn('Nao ha Leitor Cadastrado') end

	else //se existir leitores
	begin
		
	
   {$I-}
  Reset (ArqTempLeitor);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqTempLeitor);

  Seek (ArqLeitor,0);
  Seek (ArqTempLeitor, FileSize(ArqTempLeitor));


		  While (Not(Eof(ArqLeitor)))Do
		 	 Begin
		  			Read (ArqLeitor,Leitor);
				  	if(Leitor.cod = codEmpresLeitor) 
				  	then begin
				  	 
				  		Leitor_Encont := Leitor;
				  	 end

				  	 else	
				  	 begin
				  	 		Seek(ArqTempLeitor, FileSize(ArqTempLeitor));
				   		   Write (ArqTempLeitor, Leitor);
				  		end;


				end;
			   
									if Leitor_Encont.TotLivros > 0 then //Se o leitor tem livros devendo
									begin
										writeln('O Leitor (cod ', Leitor_Encont.cod, ') esta devendo um total de ', Leitor_Encont.TotLivros, ' livros a biblioteca!');
										WriteLn('E necessario a devolucao de TODOS para excluir o leitor.');
										Close(ArqLeitor);
										Close(ArqTempLeitor);
										Erase(ArqTempLeitor);
										Exclui_Leitor:=0;
									end //Se o leitor tem livros devendo

									else //Se o leitor nao tem livros devendo
									begin
							   		Close(ArqLeitor);
							   		Close(ArqTempLeitor);

												   		Erase(ArqLeitor);
							   		Exec('C:\Projects\prompt\Rename_Leitores.bat', 'parameters');
							   		writeln('Exclusao do Leitor (cod ' ,Leitor_Encont.cod,  ') Realizada com Sucesso!');
									

									end; //Se o leitor nao tem livros devendo

							   		

		 end; //se existir leitores

		  writeln('Entre com qualquer dado para continuar');
					   readln(j);
end;

function Imprime(): Integer;
begin
	 Assign (ArqLeitor,'Leitores.ARQ');
  {$I-}
  Reset (ArqLeitor);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqLeitor);
  Seek (ArqLeitor,0);
  While Not(Eof(ArqLeitor)) Do
  Begin
   Read (ArqLeitor,Leitor);
   WriteLn ('Codigo...: ', Leitor.cod);
   WriteLn ('Nome.....: ', Leitor.Nome);
   WriteLn ('Tipo.....: ', Leitor.Tipo);
   WriteLn ('Livros...: ', Leitor.TotLivros);
   writeln('');
   writeln('');
  End;
  // Fecha Arquivo
  Close (ArqLeitor);
  // Pausa no final do programa
  writeln('Entre com algum dado para mostrar os livros');
  readln(j);


  Assign (ArqLivro,'Livros.ARQ');
  {$I-}
  Reset (ArqLivro);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqLivro);
  Seek (ArqLivro,0);
  While Not(Eof(ArqLivro)) Do
  Begin
   Read (ArqLivro,Livro);
   WriteLn ('Codigo...: ', Livro.cod);
   WriteLn ('Nome.....: ', Livro.Nome);
   WriteLn ('Assunto.....: ', Livro.Classificacao);
   WriteLn ('Autor.....: ', Livro.Autor);
   WriteLn ('Editora.....: ', Livro.Editora);
   WriteLn ('Basico.....: ', Livro.Basico);
   WriteLn ('Emprestado.....: ', Livro.Emprestado);
   writeln('');
  End;
  // Fecha Arquivo
  Close (ArqLivro);
  // Pausa no final do programa
  readln(j);
end;

function Devolve_Livro(codEmpresLivro: Integer): Integer;
begin
	ClrScr;

        Assign (ArqLivro,'Livros.ARQ');
        Assign (ArqTempLivro,'LivrosTemp.ARQ');
  {$I-}
  Reset (ArqLivro);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqLivro);

   {$I-}
  Reset (ArqTempLivro);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqTempLivro);

  Seek (ArqLivro,0);
  Seek (ArqTempLivro, FileSize(ArqTempLivro));

  While (Not(Eof(ArqLivro))) Do
  Begin
  	Read(ArqLivro, Livro);

	  if(Livro.cod = codEmpresLivro)
	  then 
	  begin
	  	Livro_Encontrado := Livro;
	 end

		 else
		 begin
		 	Seek(ArqTempLivro, FileSize(ArqTempLivro));
		 	Write(ArqTempLivro, Livro);
		  end;

   end;

   if ((Livro_Encontrado.Basico = 1) or (Livro_Encontrado.Emprestado = 0)) then
				   	begin
				   		Close(ArqLivro);
				   		Close(ArqTempLivro);
				   		Devolve_Livro:= 0;
				   	end

	else
	begin



		Livro_Encontrado.Emprestado := 0;
		Livro.Data_Emprestimo := 0;
		Seek(ArqTempLivro, FileSize(ArqTempLivro));
   	Write (ArqTempLivro,Livro_Encontrado);
   	Close(ArqLivro);
   	Erase(ArqLivro);
   	Close(ArqTempLivro);
   	Exec('C:\Projects\prompt\Rename_Livros.bat', 'parameters');
   	Devolve_Livro:= 1;

	end;
end;

function Devolve_Leitor(): Integer;
begin
	ClrScr;
        writeln('Cod. do Leitor que pegou o livro emprestado:'); readln(codEmpresLeitor);
        writeln('Cod. do Livro a devolver:'); readln(codEmpresLivro);

        Assign (ArqLeitor,'Leitores.ARQ');
        Assign (ArqTempLeitor, 'LeitoresTemp.ARQ');
  {$I-}
  Reset (ArqLeitor);
  {$I+}

  if IORESULT()<>0 then
  begin WriteLn('Nao ha Leitor Cadastrado') end

	else //se existir leitores
	begin
		
	
   {$I-}
  Reset (ArqTempLeitor);
  {$I+}
  if IORESULT()<>0 then ReWrite(ArqTempLeitor);

  Seek (ArqLeitor,0);
  Seek (ArqTempLeitor, FileSize(ArqTempLeitor));


		  While (Not(Eof(ArqLeitor)))Do
		 	 Begin
		  			Read (ArqLeitor,Leitor);
				  	if(Leitor.cod = codEmpresLeitor) 
				  	then begin
				  	 
				  		Leitor_Encont := Leitor;
				  	 end

				  	 else	
				  	 begin
				  	 		Seek(ArqTempLeitor, FileSize(ArqTempLeitor));
				   		   Write (ArqTempLeitor, Leitor);
				  		end;


				end;


			   

					  
							   		Leitor_Encont.TotLivros := Leitor_Encont.TotLivros - 1;
							   		Seek(ArqTempLeitor, FileSize(ArqTempLeitor));
							   		Write(ArqTempLeitor, Leitor_Encont);
							   		Close(ArqLeitor);
							   		Close(ArqTempLeitor);

							   		if(Devolve_Livro(codEmpresLivro) = 1) then begin
							   		Erase(ArqLeitor);
							   		Exec('C:\Projects\prompt\Rename_Leitores.bat', 'parameters');
							   		writeln('Devolucao realizada com sucesso!');
							   		end

							   		else
							   		begin
							   			Erase(ArqTempLeitor);
							   			writeln('O leitor do cod', codEmpresLeitor, 'nao pegou este livro emprestado! Nao foi possivel realizar a devolucao!');
							   		end;

							   		

		 end; //se existir leitores

		  writeln('Entre com qualquer dado para continuar');
					   readln(j);
end;

	function VerificaTempoMatricula():Integer;
	begin
	ClrScr;
	Leitor_Encont.cod := 0;
	GetDate(Ano,
Mes,
Dia,
Dia_Semana);

		Assign(ArqLeitor, 'Leitores.ARQ');
  {$I-}
  Reset (ArqLeitor);
  {$I+}

  if IORESULT()<>0 then
  begin 
  	ReWrite(ArqLeitor);
  	Close(ArqLeitor);
  	VerificaTempoMatricula:=0;
   end // Se nao tiver leitres

   else
   begin
   Seek (ArqLeitor,0);

   While (Not(Eof(ArqLeitor)))Do
		 	 Begin
		 	 Leitor_Encont.cod := 0;
		  			Read (ArqLeitor,Leitor);
				  	if((Ano - Leitor.AnoCadas) > 0) 
				  	then begin
				  	 Leitor_Encont := Leitor;
				  	 break;
				  	 end; //Se achou leitor que tempo cadastro expirou

		end; //WHile

		if (Leitor_Encont.cod = 0) then
		begin
			Close(ArqLeitor);
			VerificaTempoMatricula:=0;
		end

		else
		begin
			writeln('Leitor com validade de matricula vencida (cod ', Leitor_Encont.cod, ') Excluindo Matricula...');
		Exclui_Leitor(Leitor_Encont.cod);
		end;

		ClrScr;

   end; // Se tiver leitores

	end;

begin
	VerificaTempoMatricula();
	resposta := 0;
	while(resposta <> 7) do
	begin
		ClrScr;

		writeln('Menu principal, Escolha uma das opcoes:');
		writeln('');
		writeln('1 - Cadastrar Leitor');
		writeln('2 - Incluir Livro no Acervo');
		writeln('3 - Emprestar Livro');
		writeln('4 - Excluir Leitor');
		writeln('5 - Devolucao de Livro');
		writeln('6 - Imprimir todos os dados');
		writeln('7 - Sair');
		writeln('Escolha: '); read(resposta);

		if(resposta = 1)then
		begin
			Novo_Leitor();
		end;

		 if(resposta = 2)then
		begin
			Novo_Livro();
		end;

		if(resposta = 3)then
		begin
			Saida_Livro();
		end;

		if(resposta = 4)then
		begin
			Exclui_Leitor(0);
		end;

		if(resposta = 5)then
		begin
			Devolve_Leitor();
		end;

		if(resposta = 6)then
		begin
			Imprime();
		end;


	end;

	read(resposta);
end.
