CREATE POLICY "Users can upload a profile picture h0za56_0" 
  ON storage.objects 
  FOR INSERT TO authenticated 
  WITH CHECK (
  bucket_id = 'Avatars' 
  AND auth.uid()::text = (storage.foldername(name))[1] 
  );

CREATE POLICY "Users can update their profile picture h0za56_0" 
  ON storage.objects 
  FOR UPDATE TO authenticated 
  USING (
  bucket_id = 'Avatars' 
  AND auth.uid()::text = (storage.foldername(name))[1] 
  );

CREATE POLICY "Users can update their profile picture h0za56_1" 
  ON storage.objects 
  FOR SELECT TO authenticated 
  USING (
  bucket_id = 'Avatars' 
  AND auth.uid()::text = (storage.foldername(name))[1] 
  );
